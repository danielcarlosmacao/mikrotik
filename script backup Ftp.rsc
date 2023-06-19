#Dados Manipulaveis ----------------------------------------
:global host "IP-FTP"

:global user "USER"

:global password "PASSWORD"

:global folder "destination folder"
#Dado do systema---------------------------------------------
:global voltage [/system health get value-name=psu1-voltage]

:global identification [/system identity get name]

:global hour [system clock get value-name=time]

# Gera data no formato AAAA-MM-DD 
:global data [/system clock get date]
:global meses ("jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec");
:global ano ([:pick $data 7 11])
:global mestxt ([:pick $data 0 3])
:global mm ([ :find $meses $mestxt -1 ] + 1);
:if ($mm < 10) do={ :set mm ("0" . $mm); }
:global mes ([:pick $ds 7 11] . $mm . [:pick $ds 4 6])
:global dia ([:pick $data 4 6])

:global name ("$identification" ." $dia" ."-$mes" ."-$ano"." $hour")
#Funcao
:if ($voltage<320) do={ 
/system health print file=$name
:delay 5s
/tool fetch address=$host src-path="$name.txt" user="$user" password="$password" port=21 upload=yes mode=ftp dst-path="$folder/$name.txt"
:log info "aquivo enviado"
:delay 5s
file remove $name

}