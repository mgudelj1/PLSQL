create or replace view vw_Zatezne
  ("Naziv stranke","Broj racuna","Datum Dospijeca","Datum zadnje uplate","Iznos kamate")
as
   select rc.naziv, rc.broj, rc.datum_dospijeca, max(zadnja.datum), kamate.iznos_kamate
    from (select * from
            stranke join racuni 
            using (str_id)) rc
    join (select * from 
      uplate join stavke_uplata
      using(upa_id)) zadnja
    using (rcn_id)
    
    join (select * from (select * from
                          obracuni_zateznih 
                          where rownum=1
                          order by datum_pokretanja desc)
          join (select * from stavke_obracuna
                  where iznos_kamate > 0)
                  using (ozh_id)) kamate
  using (rcn_id)
  group by rc.naziv, rc.broj, rc.datum_dospijeca, kamate.iznos_kamate
