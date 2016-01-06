#!/usr/bin/perl
######################################################################
# Gui Tranny
######################################################################
use CGI;
use CGI::Carp qw ( fatalsToBrowser );
use File::Basename qw(fileparse basename);
use Digest::MD5;
use WWW::Shorten 'TinyURL';

# Tamagno max de subida = 1G
$CGI::POST_MAX = 1024 * 1024 * 1024;
my $upload_dir = "/var/www/html/guitrani/uploads";

my $query = new CGI;
my $filename = $query->param("file");

if ( !$filename ) {
    print $query->header();
    exit;
}

my ($name,$p,$extension) = fileparse($filename);

my $d = $upload_dir . '/' . $name;
my $dd = $upload_dir . '/' . basename($filename);

# Chequear la existencia previa del archivo
if (-e $dd){
    my $agregar_nombre_repetido = '_' . int(rand(256));
    $d .= $agregar_nombre_repetido;
    $name .= $agregar_nombre_repetido;
}
$name .= $extension;
$d .= $extension;

# Escirbir el archivo.
open( UPLOADFILE, ">$d" ) or die $!;
binmode UPLOADFILE;
while (<$filename>) {
    print UPLOADFILE $_;
}
close UPLOADFILE;

my $URI_final = 'http://guitranny.hipermegared.com.ar' . '/uploads/' . $name;  
my $URI_final_Corrto = makeashorterlink($URI_final);
my $md5_archivo = md5sum($d);

print $query->header ( );
print <<END_HTML;
<html>
<head>
<!--    <link rel="stylesheet" href="http://www.semantic-ui.com/dist/components/form.css">
 -->     
                <meta charset="utf-8" />
    <title>GüiTranny</title>
                <!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.css"/> --> 
                <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/reset.css">
                <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/site.css">
                <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/container.css">
                <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/grid.css">
                <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/header.css">
                <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/image.css">
                <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/menu.css">
                <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/divider.css">
                <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/segment.css">
                <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/form.css">
                <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/input.css">
                <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/button.css">
                <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/list.css">
                <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/message.css">
    <link rel="stylesheet" type="text/css" href="http://www.semantic-ui.com/dist/components/icon.css">
                <link rel="stylesheet" type="text/css" href="https://raw.githubusercontent.com/Semantic-Org/UI-Input/master/input.css">
    <script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
    <script src="http://www.semantic-ui.com/dist/semantic.min.js"></script>
    <script src="http://www.semantic-ui.com/dist/components/form.js"></script>
    <script src="http://www.semantic-ui.com/dist/components/transition.js"></script>
<style type="text/css">
    body {
      background-color: #dbdbdb;
    }
    body > .grid {
      height: 100%;
    }
    .image {
      margin-top: -100px;
    }
    .column {
      max-width: 450px;
    }
  </style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Listo!</title>
</head>
<body>
<div class="column">
<h1>Listo!</h1>
<p>Subido correctamente en <a href="$URI_final" target="_blank">$URI_final</a>.</p>
<p>Alternativamente se puede usar este link: <a href="$URI_final_Corrto" target="_blank">$URI_final_Corrto</a>.</p>
<p>El checksum MD5 es :: <b>$md5_archivo</b> .</p>
</div></body>
</html>
END_HTML
;


######################################################################
# Subs
######################################################################

sub md5sum{
  my $file = shift;
  my $digest;
  eval{
    open(FILE, $file);
    my $ctx = Digest::MD5->new;
    $ctx->addfile(*FILE);
    $digest = $ctx->hexdigest;
    close(FILE);
  };
  return $digest;
}

