create or replace package pck_kamate
as
  procedure do_popuni_racun;
  procedure do_popuni_uplate;
end pck_kamate;


create or replace package body pck_kamate
as
  procedure do_popuni_racun
    is
 cursor c_str is
    select * from stranke;
 
v_cijena number(7,2);
v_kolicina  number;
v_proizvod number;    
v_dospijece date;
begin
  for c_rec in c_str loop
    v_kolicina := round(dbms_random.value(0.5,9999.5));
    v_proizvod := round(dbms_random.value(0.5,6.5));
    v_dospijece := to_date('01-01-2008','DD-MM-YYYY') + round(dbms_random.value(0.5,60.5));
    
    insert into racuni values
    (rcn_seq.nextval,c_rec.sifra,0,v_dospijece,c_rec.str_id); 
  
    select jed_cijena into v_cijena
      from proizvodi
      where pzd_id = v_proizvod;
    
    insert into stavke_racuna values
    (sra_seq.nextval,v_kolicina,round(v_cijena*v_kolicina,2),rcn_seq.currval,v_proizvod);
  end loop;
end do_popuni_racun;
    
procedure do_popuni_uplate
  is
  cursor c_racun is
    select * from racuni;


v_datum date;
v_koef number;
v_iznos number;
begin

  for c_rec in c_racun loop
    for i in 1..2 loop
      v_datum := to_date('01-02-2008','DD-MM-YYYY') + round(dbms_random.value(0.5,365.49));
      v_koef := round(dbms_random.value(0.01,1),5);
      
      insert into uplate(upa_id,broj,datum) values
      (upa_seq.nextval,upa_seq.currval,v_datum);
      
      insert into stavke_uplata(sue_id,upa_id,rcn_id,iznos_uplate) values
      (sue_seq.nextval,upa_seq.currval,c_rec.rcn_id,round(v_koef*c_rec.ukupan_iznos,2));
      
    end loop;
  end loop;
end do_popuni_uplate;
end pck_kamate;

