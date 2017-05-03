declare

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
  
v_rcn_id_prvi number := 0;
v_rcn_dani_prvi number := 9999;
v_iznos number;
begin

  for c_rec in c_rcn loop
    v_rcn_id := c_rec.rcn_id;
    v_iznos := 0;
     for c_rec2 in c_sue loop
        if (c_rec2.iznos_uplate >= c_rec.ukupan_iznos and (c_rec2.datum - to_date('01-01-2008')) < v_rcn_dani_prvi) then
          v_rcn_id_prvi := v_rcn_id;
          v_rcn_dani_prvi := c_rec2.datum - to_date('01-01-2008');
          exit;
        else
          v_iznos := v_iznos + c_rec2.iznos_uplate;
        end if;
        
        if(v_iznos >= c_rec.ukupan_iznos and (c_rec2.datum - to_date('01-01-2008')) < v_rcn_dani_prvi) then
          v_rcn_id_prvi := v_rcn_id;
          v_rcn_dani_prvi := c_rec2.datum - to_date('01-01-2008');
        end if;
     end loop;
  end loop;
  
dbms_output.put_line('Najbre plaæeni raèun: ' || v_rcn_id_prvi || ' i plaæen je u dana: ' || v_rcn_dani_prvi);

end;
        
      
