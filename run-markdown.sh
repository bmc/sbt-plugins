#!/bin/sh

page_title=`grep '^Title:' index.md | sed 's/^.*: //'`
temp=/tmp/index$$
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

markdown index.md >>$temp

cat <<EOF2 >>$temp
      </div>
 
      <div class="push"></div>
  </body>
</html>

EOF2

sed -e "s/{{ page.title }}/$page_title/g" <$temp >index.html

 
