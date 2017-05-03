create or replace package pck_kamate
as
  procedure do_popuni_racun;
  procedure do_popuni_uplate;
  function get_iznos_kamate
  (p_1 in racuni.ukupan_iznos%type, p_2 in racuni.ukupan_iznos%type, p_3 in date, p_4 in date)
    return number;
  procedure do_izracunaj_zatezne;
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

function get_iznos_kamate
  (p_1 in racuni.ukupan_iznos%type, p_2 in racuni.ukupan_iznos%type, p_3 in date, p_4 in date)
    return number
is
  v_kamata number(9,2);
begin
  v_kamata := (p_1 - p_2) * (p_3 - p_4) * 0.18 * (1/365);
  return v_kamata;
end get_iznos_kamate;

procedure do_izracunaj_zatezne
is
  cursor c_rcn
  is
    select * from racuni;

v_rcn_id number;

  cursor c_sue
  is
    select * from
      uplate join stavke_uplata
      using(upa_id)
      where rcn_id = v_rcn_id
      order by datum asc;
      

v_iznos_zk  number;
v_iznos_uplate_prije number;
v_iznos_uplate_poslije number;
v_datum_uplate date;

begin
  insert into obracuni_zateznih values
    (ozh_seq.nextval,ozh_seq.currval,sysdate);
    
  for c_rec in c_rcn loop
    v_rcn_id := c_rec.rcn_id;
    v_iznos_uplate_prije := 0;
    v_iznos_uplate_poslije := 0;
    v_iznos_zk := 0;
    for c_rec2 in c_sue loop
      if(c_rec2.datum <= c_rec.datum_dospijeca) then
        v_iznos_uplate_prije := v_iznos_uplate_prije + c_rec2.iznos_uplate;
        
      else 
        continue when(v_iznos_uplate_poslije + v_iznos_uplate_prije >= c_rec.ukupan_iznos);
        if(v_iznos_uplate_poslije = 0) then 
            v_iznos_zk := v_iznos_zk + pck_kamate.get_iznos_kamate
            (c_rec.ukupan_iznos,v_iznos_uplate_prije + v_iznos_uplate_poslije, c_rec2.datum,c_rec.datum_dospijeca);
            v_datum_uplate := c_rec2.datum;
          else
            v_iznos_zk := v_iznos_zk + pck_kamate.get_iznos_kamate
            (c_rec.ukupan_iznos,v_iznos_uplate_prije + v_iznos_uplate_poslije, c_rec2.datum, v_datum_uplate);
            v_datum_uplate := c_rec2.datum;
        end if; 
        v_iznos_uplate_poslije := v_iznos_uplate_poslije + c_rec2.iznos_uplate;
       end if; 
    end loop;
      case
        when (v_iznos_uplate_prije >= c_rec.ukupan_iznos) then
          v_iznos_zk := 0;
          
        when (v_iznos_uplate_prije + v_iznos_uplate_poslije = 0) then
          v_iznos_zk := pck_kamate.get_iznos_kamate
            (c_rec.ukupan_iznos,0,sysdate,c_rec.datum_dospijeca);
            
        when (v_iznos_uplate_poslije > 0 and (v_iznos_uplate_poslije + v_iznos_uplate_prije) < c_rec.ukupan_iznos) then
          v_iznos_zk := v_iznos_zk + pck_kamate.get_iznos_kamate
            (c_rec.ukupan_iznos,v_iznos_uplate_prije + v_iznos_uplate_poslije,sysdate,c_rec.datum_dospijeca);
        else v_iznos_zk := v_iznos_zk;
      end case;  
    insert into stavke_obracuna values
    (soa_seq.nextval,ozh_seq.currval,c_rec.rcn_id,round(v_iznos_zk,2));
  end loop;
end do_izracunaj_zatezne;
end pck_kamate;