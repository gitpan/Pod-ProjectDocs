package Pod::ProjectDocs::CSS;
use strict;
use warnings;
use base qw/Pod::ProjectDocs::File/;
use File::Basename;

__PACKAGE__->default_name('podstyle.css');
__PACKAGE__->data( do{ local $/; <DATA> } );

sub tag {
	my($self, $doc) = @_;
	my($name, $path) = fileparse $doc->_get_output_path, qw/\.html/;
	my $relpath = File::Spec->abs2rel($self->_get_output_path, $path);
	return sprintf qq|<link rel="stylesheet" type="text/css" href="%s" />|, $relpath;
}

1;
__DATA__

BODY, .logo { background: white; }

BODY {
  color: black;
  font-family: arial,sans-serif;
  margin: 0;
  padding: 1ex;
}

TABLE {
  border-collapse: collapse;
  border-spacing: 0;
  border-width: 0;
  color: inherit;
}

IMG { border: 0; }
FORM { margin: 0; }
input { margin: 2px; }

.logo {
  float: left;
  width: 264px;
  height: 77px;
}

.front .logo  {
  float: none;
  display:block;
}

.front .searchbox  {
  margin: 2ex auto;
  text-align: center;
}

.front .menubar {
  text-align: center;
}

.menubar {
  background: #006699;
  margin: 1ex 0;
  padding: 1px;
} 

.menubar A {
  padding: 0.8ex;
  font: bold 10pt Arial,Helvetica,sans-serif;
}

.menubar A:link, .menubar A:visited {
  color: white;
  text-decoration: none;
}

.menubar A:hover {
  color: #ff6600;
  text-decoration: underline;
}

A:link, A:visited {
  background: transparent;
  color: #006699;
}

A[href="#POD_ERRORS"] {
  background: transparent;
  color: #FF0000;
}

TD {
  margin: 0;
  padding: 0;
}

DIV {
  border-width: 0;
}

DT {
  margin-top: 1em;
}

.credits TD {
  padding: 0.5ex 2ex;
}

.huge {
  font-size: 32pt;
}

.s {
  background: #dddddd;
  color: inherit;
}

.s TD, .r TD {
  padding: 0.2ex 1ex;
  vertical-align: baseline;
}

TH {
  background: #bbbbbb;
  color: inherit;
  padding: 0.4ex 1ex;
  text-align: left;
}

TH A:link, TH A:visited {
  background: transparent;
  color: black;
}

.box {
  border: 1px solid #006699;
  margin: 1ex 0;
  padding: 0;
}

.distfiles TD {
  padding: 0 2ex 0 0;
  vertical-align: baseline;
}

.manifest TD {
  padding: 0 1ex;
  vertical-align: top;
}

.l1 {
  font-weight: bold;
}

.l2 {
  font-weight: normal;
}

.t1, .t2, .t3, .t4  {
  background: #006699;
  color: white;
}
.t4 {
  padding: 0.2ex 0.4ex;
}
.t1, .t2, .t3  {
  padding: 0.5ex 1ex;
}

/* IE does not support  .box>.t1  Grrr */
.box .t1, .box .t2, .box .t3 {
  margin: 0;
}

.t1 {
  font-size: 1.4em;
  font-weight: bold;
  text-align: center;
}

.t2 {
  font-size: 1.0em;
  font-weight: bold;
  text-align: left;
}

.t3 {
  font-size: 1.0em;
  font-weight: normal;
  text-align: left;
}

/* width: 100%; border: 0.1px solid #FFFFFF; */ /* NN4 hack */

.datecell {
  text-align: center;
  width: 17em;
}

.cell {
  padding: 0.2ex 1ex;
  text-align: left;
}

.label {
  background: #aaaaaa;
  color: black;
  font-weight: bold;
  padding: 0.2ex 1ex;
  text-align: right;
  white-space: nowrap;
  vertical-align: baseline;
}

.categories {
  border-bottom: 3px double #006699;
  margin-bottom: 1ex;
  padding-bottom: 1ex;
}

.categories TABLE {
  margin: auto;
}

.categories TD {
  padding: 0.5ex 1ex;
  vertical-align: baseline;
}

.path A {
  background: transparent;
  color: #006699;
  font-weight: bold;
}

.pages {
  background: #dddddd;
  color: #006699;
  padding: 0.2ex 0.4ex;
}

.path {
  background: #dddddd;
  border-bottom: 1px solid #006699;
  color: #006699;
 /*  font-size: 1.4em;*/
  margin: 1ex 0;
  padding: 0.5ex 1ex;
}

.menubar TD {
  background: #006699;
  color: white;
}

.menubar {
  background: #006699;
  color: white;
  margin: 1ex 0;
  padding: 1px;
}

.menubar .links     {
  background: transparent;
  color: white;
  padding: 0.2ex;
  text-align: left;
}

.menubar .searchbar {
  background: black;
  color: black;
  margin: 0px;
  padding: 2px;
  text-align: right;
}

A.m:link, A.m:visited {
  background: #006699;
  color: white;
  font: bold 10pt Arial,Helvetica,sans-serif;
  text-decoration: none;
}

A.o:link, A.o:visited {
  background: #006699;
  color: #ccffcc;
  font: bold 10pt Arial,Helvetica,sans-serif;
  text-decoration: none;
}

A.o:hover {
  background: transparent;
  color: #ff6600;
  text-decoration: underline;
}

A.m:hover {
  background: transparent;
  color: #ff6600;
  text-decoration: underline;
}

table.dlsip     {
  background: #dddddd;
  border: 0.4ex solid #dddddd;
}

.pod PRE     {
  background: #eeeeee;
  border: 1px solid #888888;
  color: black;
  padding: 1em;
  white-space: pre;
}

.pod H1      {
  background: transparent;
  color: #006699;
  font-size: large;
}

.pod H2      {
  background: transparent;
  color: #006699;
  font-size: medium;
}

.pod IMG     {
  vertical-align: top;
}

.pod .toc A  {
  text-decoration: none;
}

.pod .toc LI {
  line-height: 1.2em;
  list-style-type: none;
}

.faq DT {
  font-size: 1.4em;
  font-weight: bold;
}

.chmenu {
  background: black;
  color: red;
  font: bold 1.1em Arial,Helvetica,sans-serif;
  margin: 1ex auto;
  padding: 0.5ex;
}

.chmenu TD {
  padding: 0.2ex 1ex;
}

.chmenu A:link, .chmenu A:visited  {
  background: transparent;
  color: white;
  text-decoration: none;
}

.chmenu A:hover {
  background: transparent;
  color: #ff6600;
  text-decoration: underline;
}

.column {
  padding: 0.5ex 1ex;
  vertical-align: top;
}

.datebar {
  margin: auto;
  width: 14em;
}

.date {
  background: transparent;
  color: #008000;
}

.footer {
  margin-top: 1ex;
  text-align: right;
  color: #006699;
  font-size: x-small;
  border-top: 1px solid #006699;
  line-height: 120%;
}

.front .footer {
  border-top: none;
}

