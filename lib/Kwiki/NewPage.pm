package Kwiki::NewPage;
use strict;
use warnings;
use Kwiki::Plugin '-Base';
use mixin 'Kwiki::Installer';
use Kwiki ':char_classes';
our $VERSION = '0.11';

const class_id => 'new_page';
const class_title => 'New Page';
const cgi_class => 'Kwiki::NewPage::CGI';

sub register {
    my $registry = shift;
    $registry->add(action => 'new_page');
    $registry->add(toolbar => 'new_page_button', 
                   template => 'new_page_button.html',
                  );
}

sub new_page {
    my $error_msg = '';
    if ($self->cgi->button) {
        $error_msg = $self->check_page_name or do {
            my $redirect = "action=edit&page_id=" . $self->cgi->new_page_id;
            return $self->redirect($redirect);
        }
    }
    $self->render_screen(
        error_msg => $error_msg,
    );
}

sub check_page_name {
    my $page_id = $self->cgi->new_page_id;
    return "There is already a page named '$page_id'."
      if $self->pages->new_page($page_id)->exists;
    return "'$page_id' is an invalid page name. Can't contain spaces."
      if $page_id =~ /\s/;
    return "'$page_id' is an invalid page name. Invalid characters."
      unless $page_id =~ /^[$WORD]+$/;
    return;
}

package Kwiki::NewPage::CGI;
use Kwiki::CGI '-base';

cgi 'new_page_id';

package Kwiki::NewPage;
1;
__DATA__

=head1 NAME 

Kwiki::NewPage - Kwiki New Page Plugin

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

Brian Ingerson <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2004. Brian Ingerson. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
__template/tt2/new_page_button.html__
<!-- BEGIN new_page_button.html -->
<a href="[% script_name %]?action=new_page" accesskey="N" title="Create New Page">
[% INCLUDE new_page_button_icon.html %]
</a>
<!-- END new_page_button.html -->
__template/tt2/new_page_button_icon.html__
<!-- BEGIN new_page_button_icon.html -->
New
<!-- END new_page_button_icon.html -->
__template/tt2/new_page_content.html__
<!-- BEGIN new_page_content.html -->
[% screen_title = 'Create New Page' %]
<form method="post">
<p>Enter a new page name:</p>
<input type="text" size="20" maxlength="30" name="new_page_id" value="[% new_page_id %]" />
<input type="submit" name="button" value="CREATE" />
<br />
<br />
<span class="error">[% error_msg %]</span>
<input type="hidden" name="action" value="new_page">
</form>
<pre>


</pre>
<!-- END new_page_content.html -->
