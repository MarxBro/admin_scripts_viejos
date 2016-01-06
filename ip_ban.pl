#!/usr/bin/perl
##########################################################################
# Script para banear ips, creando reglas iptables. 
# CentOs6
##########################################################################

use warnings;

# Muere si no hay ips en la entrada.
die "No hube Ips. FINAL NO FELIZ." unless $ARGV[0];

my @ip_ban_list = @ARGV;

#print @ip_ban_list;
###############################################################
# Comando estrella -> BAN todos DROPS...
###############################################################
my $COM_pre_ip  = 'iptables -A INPUT -s ';
my $COM_post_ip = ' -p tcp -j DROP';

###############################################################
# Vender un poco de humo con la consola.
###############################################################
my $msg_CLI = q|
=================================================
==      ip_ban.pl
=================================================
        Script para banear direcciones ip creando
        reglas iptables.

        MODO DE USO / AYUDA
        --------------------

_ip_ban.pl 100.21.21.78 127.0.0.1 124.5.7.57
                
                Direcciones ip separadas por espacios en
                blanco. Por cada una se crea una regla
                iptable, que la banea dropeando los
                paquetes TCP y UDP desde/hacia ella.

_ip_ban.pl [-h/-u/ERROR_ARGV]
                Esta ayuda, STDOUT o STDERR segun el
                caso.

=================================================
==      Zaijian.        GsTv.2012.
=================================================
|;

sub help_usage {
    my $st = shift(@_);
    if ( $st == 1 ) {
        print STDERR $msg_CLI && exit 1;
    }
    else {
        print $msg_CLI && exit 0;
    }

}

###############################################################
# funcion de CHEQUEO y CONFIRMACION + subfunciones.
# OJO!                          LLAMA A BAN SOBRE EL FINAL!!!
###############################################################
sub error_argys {

    # LLAMADO POR confirmacion();
    my $argy_k = shift(@_);
    print STDERR <<DF
--------------------------------------------------
Error!
El argumento: $argy_k
no es una direccion IP valida. Sera ignorada,
revise si los numeros entre puntos son menores a
256; direcciones IPV6 no son soportadas aun.
--------------------------------------------------
                ----      ----
DF
      ;
}

sub confirmacion {
#    my $index = 0;
#    foreach my $argy (@ip_ban_list) {
#               my @argy_partes = split(/\./, $argy);
#               foreach my $parte (@argy_partes){
#                       if ($parte =~ /\w+/){
#                               next;
#                       } elsif ($parte >= 256 || $parte <= 0 ) {
#                               error_argy($argy);
#                               delete( $ip_ban_list[$index] );
#                       }
#               }
#        unless (( $argy =~ /\./ || $argy =~ /\d{1,3}/ ) || ($argy ne "undef" )) {
#            error_argy($argy);
#            delete( $ip_ban_list[$index] );
#        }
#        $index++;
#    }
    print "Las siguientes direeciones IP seran baneadas:" . "\n";
    foreach my $argy (@ip_ban_list){
                print 'BAN ->' . "$argy" . "\n";
        }
        print 'Seguir ??? (n para NO, cualquier cosa para SI) :';
        if (<STDIN> =~ /n+/) {
                print 'Cancelado por Usuario.' . "\n";
                exit 0;
        } else {
                print "Continuando.." . "\n" &&
                banear();
        }

}
###############################################################
# funcion BAN + subfunciones.
###############################################################
sub banear {
        #LLAMADO POR confirmacion();
    foreach my $ip (@ip_ban_list) {
        if ( $ip ) {
            my $iptables_COM = $COM_pre_ip . $ip . $COM_post_ip;
            `$iptables_COM`;
            #print $iptables_COM;
            if ( $? == 1 ) {
                status_msg( $ip, 1 );
            } else {
                status_msg( $ip, 0 );
                iptables_save($?);
            }
        }
    }
   #iptables_save($st_ip_loop);
}

sub status_msg {
        # LLAMADO POR banear();
    my $ip = $_[0];
    if ( $_[1] == 1 ) {
        print <<BASTA
Error!
El comando para la IP $ip FALLO!
......
BASTA
          ;
    }
    else {
        print <<BASTA__
BAN -> $ip CORRECTO...
Continuando...
BASTA__
          ;
    }
}

sub iptables_save {
        # LLAMADO por banear();

        `service iptables save`;
          
          print <<OK
Guardando nuevas reglas de iptables...
=============================================
== EXITO!                               GsTv. 2012.
=============================================
OK
          ;
#          exit 0;


}

###############################################################
# EJECUCION PRINCIPAL DEL CODIGO
###############################################################
if (($ip_ban_list[0] eq '-h') or ($ip_ban_list[0] eq '-u')){
        # Ayuda
        help_usage(0);
} elsif (($ip_ban_list[0] =~ /-\w{1,5}/) or ($ip_ban_list[0] eq "")){
        # Ayuda en STDERR
        help_usage(1);
} else {
        #Ejecucion de las funciones encadenadas
        confirmacion() && exit 0;
}
###############################################################
# Zaijian                                               GsTv.2012.
###############################################################

