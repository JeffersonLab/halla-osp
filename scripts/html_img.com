#! /bin/bash

# -- Used in the derectory created by latex2html 
# -- Copies all png,jpg images to the directory and replaces the file names
# Input parameter: directory path

  PROG=`basename $0`
  path=$1

  if ! test -d $path ; then
    echo Error in $PROG : directory=$path is missing
    exit
  fi

  cd $path
  cd ../
  dirw=`pwd`  # name for the "work" directory where latex2html ran
  cd $path

  k=0
  if ! test -f node1.html ; then
    echo Error in $PROG : no node1.html file in directory=$path
    exit
  fi
 
  for i in `ls -1 node*.html`; do
    cp $i tmp1
    for suf in \.jpg \.png ; do
      a=`grep $suf tmp1 | grep $dirw | grep -i 'src='`
      if ! test -z "$a" ; then
#          echo Found $a
          for w in `echo $a | sed s/\"//g | sed s/SRC\=//g | sed s/src\=//g` ; do
             echo $w | grep $dirw >& /dev/null
             if [ $? -eq 0 ]; then
#               echo w=$w
               k=`expr $k + 1`  # image number
               img=mimg$k$suf
               cat tmp1 | sed s"#$w#$img#"g > tmp2
               cp tmp2 tmp1
               cp $w $img
             fi
          done
      fi
    done
    cp tmp1 $i
  done

  [ -f tmp1 ] && rm -f tmp1
  [ -f tmp2 ] && rm -f tmp2
  echo html_img.com finished
# ===========  CVS info
# $Header: /group/halla/analysis/cvs/tex/osp/scripts/html_img.com,v 1.1 2003/06/05 17:28:33 gen Exp $
# $Id: html_img.com,v 1.1 2003/06/05 17:28:33 gen Exp $
# $Author: gen $
# $Date: 2003/06/05 17:28:33 $
# $Name:  $
# $Locker:  $
# $Log: html_img.com,v $
# Revision 1.1  2003/06/05 17:28:33  gen
# Initial revision
#
