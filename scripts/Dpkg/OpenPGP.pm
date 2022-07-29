# Copyright © 2017 Guillem Jover <guillem@debian.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

package Dpkg::OpenPGP;

use strict;
use warnings;

use Dpkg::Gettext;
use Dpkg::ErrorHandling;
use Dpkg::IPC;
use Dpkg::Path qw(find_command);
use Dpkg::OpenPGP::Backend::GnuPG;

our $VERSION = '0.01';

sub new {
    my ($this, %opts) = @_;
    my $class = ref($this) || $this;

    my $self = {};
    bless $self, $class;

    my %backend_opts = (
        cmdv => $opts{cmdv} // 'auto',
        cmd => $opts{cmd} // 'auto',
    );

    $self->{backend} = Dpkg::OpenPGP::Backend::GnuPG->new(%backend_opts);

    return $self;
}

sub can_use_secrets {
    my ($self, $key) = @_;

    return 0 unless $self->{backend}->has_backend_cmd();

    if ($key->type eq 'keyfile') {
        return 1 if -f $key->handle;
    } elsif ($key->type eq 'keystore') {
        return 1 if -e $key->handle;
    } else {
        # For IDs we need a keystore.
        return $self->{backend}->has_keystore();
    }
    return 0;
}

sub get_trusted_keyrings {
    my $self = shift;

    return $self->{backend}->get_trusted_keyrings();
}

sub armor {
    my ($self, $type, $in, $out) = @_;

    return $self->{backend}->armor($type, $in, $out);
}

sub dearmor {
    my ($self, $type, $in, $out) = @_;

    return $self->{backend}->dearmor($type, $in, $out);
}

sub inline_verify {
    my ($self, $inlinesigned, $data, @certs) = @_;

    return $self->{backend}->inline_verify($inlinesigned, $data, @certs);
}

sub verify {
    my ($self, $data, $sig, @certs) = @_;

    return $self->{backend}->verify($data, $sig, @certs);
}

sub inline_sign {
    my ($self, $data, $inlinesigned, $key) = @_;

    return $self->{backend}->inline_sign($data, $inlinesigned, $key);
}

1;
