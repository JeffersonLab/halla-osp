#!/bin/bash

# Parses the name list, checks the "staff" data and creates latex commands

#----------------------------
echo " Disable names.tex generation from src/people/names.txt"
echo "   - src/people/names.txt is out of date, $0 should NOT be run"
echo "   - names.tex is now the primary source file"

exit 0
#----------------------------

PROG=`basename $0`
echo Started $PROG to build a LaTeX file with a list of personnel ... 

[ -f tmp ] && rm -f tmp
fil_inp=names.txt
fil_out=names.tex
fil_log=names.log

[ -f $fil_out ] && rm -f $fil_out
[ -f $fil_log ] && rm -f $fil_log

ys=0
which staff &>/dev/null ; [ $? -eq 0 ] && ys=1  

nth=`cat $fil_inp | wc -l`
if [ $nth -gt 0 ]; then
  i=0; while i=`expr $i + 1`; [ $i -le $nth ]; do
    lin=`head -$i $fil_inp | tail -1`   
    nf=`echo $lin | awk '{print NF}'`
    lnamf=`echo $lin | awk '{print $1}'`
    fnamf=`echo $lin | awk '{print $2}'`
    lnam=$(echo $lnamf | sed s"/[\^\`\'\{\}]//"g)
    fnam=$(echo $fnamf | sed s"/[\^\`\'\{\}]//"g)
    inst=""     ; [ $nf -gt 2 ] && inst=`echo $lin | awk '{print $3}'`
    etel=""     ; [ $nf -gt 3 ] && etel=`echo $lin | awk '{print $4}'`
    eml=""      ; [ $nf -gt 4 ] &&  eml=`echo $lin | awk '{print $5}'`
    pag=""
#    echo $lnam $fnam /$etel/ >> $fil_log
    [ -n "$etel" ] && echo $etel | grep '[0-9]' &>/dev/null 
    if [ $? -eq 0 ]; then
       echo $inst | grep JLab &>/dev/null ; [ $? -ne 0 ] && etel=$etel\\cite{inst:$inst}
    fi
    if [ $ys -gt 0 ]; then
       lin1=`staff $lnam | grep $fnam | sed s"/\%/ /"`
       if [ -n "$lin1" ]; then
          tel=`echo "$lin1" | cut -c27-30`
          pag=`echo "$lin1" | cut -c39-42`
          eml=`echo "$lin1" | awk '{print $NF"@jlab.org"}'`
          etel=$tel
       else
          echo Missing form staff: $lnam  $fnam >> $fil_log
       fi 
    fi
    com=`echo $fnam$lnam | sed s"/[-~]//"g`
    echo $eml | grep '[a-z]' &>/dev/null ; [ $? -eq 0 ] && eml=\\email\{$eml\}
    echo \\newcommand{\\$com}[1]{$fnamf $lnamf \& $inst \& $etel \& $pag \& "$eml" \& \#1 \\\\ } >> $fil_out
  done
  echo Finished.
fi


