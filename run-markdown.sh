#!/bin/sh

case "$#" in
    1)
        in=$1
        base=`basename $1 .md`
        out=$base.html
        ;;
    *)
        echo "Usage: $0 mdfile" >&2
        exit 1
esac

if [ ! -f $in ]
then
    echo "No such file -- $in" >&2
    exit 1
fi

page_title=`grep '^title:' $in | sed 's/^.*: //'`
layout=`grep '^layout:' $in | sed 's/^.*: //'`
layout=`grep '^author:' $in | sed 's/^.*: //'`
email=`grep '^email:' $in | sed 's/^.*: //'`
temp=/tmp/$base$$
cat <<EOF1 >$temp
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
    <title>{{ page.title }}</title>
    <link href="stylesheets/screen.css" media="screen" rel="stylesheet" type="text/css" />
  </head>
  <body>
      <table class="banner" cellpadding="2" cellspacing="0" width="100%">
        <tr valign="bottom">
          <td width="82"><img src="images/clapper-logo.png" width="82" height="81"/></td>
          <td><span class="title">{{ page.title }}</span></td>
        </tr>
      </table>
      <br clear="all"/>
      <hr/>
      <div id="content" class="site">
EOF1

temp2=/tmp/${base}2$$
awk '
BEGIN    {suppress = 0}
/^---/   {suppress += 1; if (suppress <= 2) next;}
         {if (suppress > 1) print $0}' <$in >$temp2

markdown $temp2 >>$temp
rm -f $temp2

cat <<EOF2 >>$temp
      </div>
 
      <div class="push"></div>
  </body>
</html>

EOF2

sed -e "s/{{ page.title }}/$page_title/g" \
    -e "s/{{ page.author }}/$author/g" \
<$temp >$out
rm -f $temp

 
