select sifra,naziv 
  from stavke_obracuna join racuni
    using(rcn_id)
  join stranke 
    using(str_id)
  where iznos_kamate = (select max(iznos_kamate)
                              from stavke_obracuna);
    