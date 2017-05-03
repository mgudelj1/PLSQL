select rcn_id, prvi.datum_pokretanja as "1.datum", prvi.iznos_kamate as "1. kamate", drugi.datum_pokretanja as "2.datum", drugi.iznos_kamate as "2. kamate",
        prvi.iznos_kamate  - drugi.iznos_kamate as razlika
  from (select * from
          obracuni_zateznih join stavke_obracuna
          using(ozh_id)
          where datum_pokretanja = 
          (select datum_pokretanja from (select row_number() over (order by datum_pokretanja desc) as RWNM, obracuni_zateznih.*
                      from obracuni_zateznih)
          where RWNM = 1)) prvi
    join
  (select * from
          obracuni_zateznih join stavke_obracuna
          using(ozh_id)
          where datum_pokretanja = 
          (select datum_pokretanja from (select row_number() over (order by datum_pokretanja desc) as RWNM, obracuni_zateznih.*
                      from obracuni_zateznih)
          where RWNM = 2)) drugi
    using(rcn_id)
    order by rcn_id;
  
  