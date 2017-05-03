b)
create or replace package pck_kamate
as
  procedure do_popuni_racun;
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
    
end pck_kamate;




c)
create or replace trigger tr_racuni_ukiznos
for insert or update on stavke_racuna
compound trigger
  v_ukiznos number(9,2) := 0;
  v_rcn_id number;
  
before statement is
begin
  v_rcn_id := :new.rcn_id;
end before statement;
  
after statement is 
begin
  select sum(cijena) into v_ukiznos
    from stavke_racuna
    where rcn_id = v_rcn_id;
      
  update racuni
    set ukupan_iznos = v_ukiznos
    where rcn_id = v_rcn_id;
end after statement;
end tr_racuni_ukiznos;