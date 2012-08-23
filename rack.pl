#!/usr/bin/perl -w

# * ----------------------------------------------------------------------------
# * « LICENCE BEERWARE » (Révision 42):
# * <loic.porte@bibabox.fr> a créé ce fichier. Tant que vous conservez cet avertissement,
# * vous pouvez faire ce que vous voulez de ce truc. Si on se rencontre un jour et
# * que vous pensez que ce truc vaut le coup, vous pouvez me payer une bière en
# * retour. PORTE Loïc
# * ----------------------------------------------------------------------------

#############################################
# Build a map for nagvis with basic array : #
# to execute : ./rack.pl                    #
# By PORTE Loïc                             #
#############################################

use strict;
use warnings;

#DEFINE HARDWARE
# type : switch 1U / server 1U 2U / battery 3U
# to add type add corespond picture.

my $baies = {
    "Baie n°1"   => {
        'size'    => 42,
        'materiel' => {
            "srv-test"       => {'size'=>2,'location'=> 40,'type'=>'server'},
            "srv-virtu"       => {'size'=>1,'location'=> 6,'type'=>'server'},
            "srv-monitoring"    => {'size'=>1,'location'=> 5,'type'=>'server'},
        },
     },
    "Baie n°2"    => {
        'size'      => 42,
        'materiel'   => {
            "netgear"           =>  {'size'=>1,'location'=>41,'type'=>'switch'},
            "srv-web"            =>  {'size'=>2,'location'=>18,'type'=>'server'},
            "srv-bdd"               =>  {'size'=>2,'location'=>16,'type'=>'server'},
            "srv-domain"           =>  {'size'=>2,'location'=>14,'type'=>'server'},
            "srv-win2K3"              =>  {'size'=>2,'location'=>12,'type'=>'server'},
            "srv-crm"             =>  {'size'=>2,'location'=>10,'type'=>'server'},
            "srv-alert"            =>  {'size'=>2,'location'=>8,'type'=>'server'},
            "battery"               =>  {'size'=>3,'location'=>2,'type'=>'battery'},
            "battery2"              =>  {'size'=>3,'location'=>5,'type'=>'battery'},
        },
    },
};

#DEFINE STATIC
#Size of 1U
my $h = 14;
my $w = 158;

#Marge
my $h_marge = 16;
my $current_c = 100;

#color
my $baie_color = '#000000';
my $baie_w = 4;

#Label
my $lbl_w = 90;
my $lbl_h = 10;
my $lbl_marge = 15; #marge between label and baie
#FUNCTION
sub draw_baie{
    my ($name,$size) = @_;

    my $x_lbl = $current_c + $w/2 - $lbl_w/2;
    # draw Label
    print "define textbox {\n";
    print "text=$name\n";
    print "x=$x_lbl\n";
    print "y=$h_marge\n";
    print "h=$lbl_h\n";
    print "w=$lbl_w\n";
    print "}\n";
    
        
    my $y1 = $h_marge + $lbl_h + $lbl_marge;
    my $y2 = $y1+$size*$h+$baie_w*2;
    my $y3 = $y1 - $baie_w/2;
    my $y4 = $y2 - $baie_w/2;
    
    my $current_c1 = $current_c + $w + $baie_w*2 ;
    my $x2 = $current_c - $baie_w/2;
    my $x3 = $current_c +$w + $baie_w + $baie_w/2;
    
    # draw baie line
    print "define line {\n";
    print "line_width=$baie_w\n";
    print "line_color=$baie_color\n";
    print "line_color_border=$baie_color\n";
    print "x=$current_c,$current_c\n";
    print "y=$y1,$y2\n";
    print "line_type=12\n";
    print "}\n";

    print "define line {\n";
    print "line_width=$baie_w\n";
    print "line_color=$baie_color\n";
    print "line_color_border=$baie_color\n";
    print "x=$current_c1,$current_c1\n";
    print "y=$y1,$y2\n";
    print "line_type=12\n";
    print "}\n";
    
    print "define line {\n";
    print "line_width=$baie_w\n";
    print "line_color=$baie_color\n";
    print "line_color_border=$baie_color\n";
    print "x=$x2,$x3\n";
    print "y=$y3,$y3\n";
    print "line_type=12\n";
    print "}\n";
    
    print "define line {\n";
    print "line_width=$baie_w\n";
    print "line_color=$baie_color\n";
    print "line_color_border=$baie_color\n";
    print "x=$x2,$x3\n";
    print "y=$y4,$y4\n";
    print "line_type=12\n";
    print "}\n";

}

sub draw_materiel{
    my ($name,$baie_size,$size,$location,$type) = @_;
    
    my $x_pos=$current_c+$baie_w;
    my $y_pos=$h_marge + $lbl_h + $lbl_marge + $baie_w/2  + $baie_size*$h-$location*$h-$size*$h +$h;
    
    print "define shape {\n";
    print "icon=$type"."_"."$size.png\n";
    print "x=$x_pos\n";
    print "y=$y_pos\n";
    print "}\n";


    $y_pos = $y_pos+($size*$h)/2-$h/2;

    print "define host {\n";
    print "host_name=$name\n";
    print "x=$x_pos\n";
    print "y=$y_pos\n";
    print "iconset=std_small\n";
    print "}\n";

}

sub draw_template{
    print "define global {\n";
    print "background_color=#C0C0C0\n";
    print "}\n";
}

#LOOP
draw_template();
foreach my $baie_name ( sort(keys(%$baies)) ){
    my $baie = $baies->{$baie_name};
    draw_baie($baie_name,$baie->{size});

    foreach my $server_name (keys(%{$baie->{materiel}})){
        my $server = $baie->{materiel}->{$server_name};
        draw_materiel($server_name,$baie->{size}, $server->{size},$server->{location},$server->{type})
    }
    $current_c += $w+$baie_w*2+15;
}
