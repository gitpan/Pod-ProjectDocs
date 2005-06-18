package Pod::ProjectDocs::IndexPage;
use strict;
use base qw/Pod::ProjectDocs::File/;
use Template;

__PACKAGE__->default_name('index.html');
__PACKAGE__->data( do{ local $/; <DATA> } );

sub _save_data {
	my $self   = shift;
	my %params = @_;
	$params{css} = $params{css}->tag($self);
	$params{charset} ||= 'UTF-8';
	my $text = '';
	my $tt = Template->new({
		FILTERS => {
			return2br => sub {
				my $text = shift;
				$text =~ s!\r\n!<br />!g;
				$text =~ s!\n!<br />!g;
				return $text;
			},
		},
	});
	my $html = $self->data;
	$tt->process(\$html, \%params, \$text)
		or $self->_croak($tt->error);
	return $text;
}

1;
__DATA__
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=[% charset %]">
<title>[% title | html %]</title>
[% css %]
</head>
<body>
<div class="box">
  <h1 class="t1">[% title %]</h1>
  <table>
    <tr>
      <td class="label">Description</td>
      <td class="cell">[% desc | return2br %]</td>
    </tr>
  </table>
</div>
[% IF mans.size %]
<div class="box">
<h2 class="t2">Manuals</h2>
  <table width="100%">
    [% seq = 1 %]
    [% FOREACH doc IN mans %]
    <tr class="[% IF seq mod 2 == 1 %]r[% ELSE %]s[% END %]">
      <td nowrap="nowrap">
        <a href="[% doc.rel_path %]">[% doc.name %]</a>
      </td>
      <td width="99%">
        <small>[% doc.title %]</small>    
      </td>
    </tr>
    [% seq = seq + 1 %]
    [% END %]
  </table>
</div>
[% END %]
[% IF docs.size %]
<div class="box">
<h2 class="t2">Modules</h2>
  <table width="100%">
    [% seq = 1 %]
    [% FOREACH doc IN docs %]
    <tr class="[% IF seq mod 2 == 1 %]r[% ELSE %]s[% END %]">
      <td nowrap="nowrap">
      [% IF doc.has_document %]
        <a href="[% doc.rel_path %]">[% doc.name %]</a>
      [% ELSE %]
        [% doc.name %]
      [% END %]
      </td>
      <td width="99%">
        <small>[% doc.title %]</small>    
      </td>
    </tr>
    [% seq = seq + 1 %]
    [% END %]
  </table>
</div>
[% END %]
</body>
</html>


