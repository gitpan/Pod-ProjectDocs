package Pod::ProjectDocs::IndexPage;
use strict;
use warnings;
use base qw/Pod::ProjectDocs::File/;
use Pod::ProjectDocs::Template;

__PACKAGE__->default_name('index.html');
__PACKAGE__->data( do{ local $/; <DATA> } );

__PACKAGE__->mk_accessors(qw/managers components/);

sub _init {
	my($self, %args) = @_;
	$self->SUPER::_init(%args);
	$self->managers(   $args{managers}   );
	$self->components( $args{components} );
}

sub _get_data {
	my $self = shift;
	my $params = {
		title    => $self->config->title,
		desc     => $self->config->desc,
		managers => $self->managers,
		css      => $self->components->{css}->tag($self),
		charset  => $self->config->charset || 'UTF-8',
	};
	my $tt = Pod::ProjectDocs::Template->new;
	my $text = $tt->process($self, $self->data, $params);
	return $text;
}

1;
__DATA__
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=[% charset %]" />
<title>[% title | html %]</title>
[% css %]
</head>
<body>
<div class="box">
  <h1 class="t1">[% title | html %]</h1>
  <table>
    <tr>
      <td class="label">Description</td>
      <td class="cell">[% desc | return2br %]</td>
    </tr>
  </table>
</div>
[% FOREACH manager IN managers %]
[% IF manager.docs.size %]
<div class="box">
<h2 class="t2">[% manager.desc | html %]</h2>
  <table width="100%">
    [% seq = 1 %]
    [% FOREACH doc IN manager.docs %]
    <tr class="[% IF seq mod 2 == 1 %]r[% ELSE %]s[% END %]">
      <td nowrap="nowrap">
        <a href="[% doc.relpath %]">[% doc.name | html %]</a>
      </td>
      <td width="99%">
        <small>[% doc.title | html %]</small>
      </td>
    </tr>
    [% seq = seq + 1 %]
    [% END %]
  </table>
</div>
[% END %]
[% END %]
</body>
</html>
