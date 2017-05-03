create table stranke(
    str_id  number
   ,sifra varchar2(20) not null unique
   ,naziv varchar2(20) not null
   ,constraint str_pk primary key (str_id)
   );

create table proizvodi(
    pzd_id  number
   ,sifra varchar2(20) not null unique
   ,naziv varchar2(20) not null
   ,jed_cijena  number(7,2) not null
   ,constraint pzd_pk primary key (pzd_id)
   );
   
create table racuni(
    rcn_id  number
   ,broj  varchar2(20) not null unique
   ,ukupan_iznos  number(9,2) not null
   ,datum_dospijeca date not null
   ,str_id  number not null
   ,constraint rcn_pk primary key (rcn_id)
   ,constraint rcn_str_fk foreign key (str_id)
   references stranke(str_id)
   );

create table stavke_racuna(
    sra_id  number
    ,kolicina number(4) not null
    ,cijena number(9,2) not null
    ,rcn_id number
    ,pzd_id number
    ,constraint sra_pk primary key (sra_id)
    ,constraint sra_rcn_fk foreign key (rcn_id)
    references racuni(rcn_id)
    ,constraint sra_pzd_fk foreign key (pzd_id)
    references proizvodi(pzd_id)
    );

create table uplate(
    upa_id  number
    ,broj varchar2(20) not null unique
    ,datum date not null
    ,constraint upa_pk primary key (upa_id)
    );
    
create table stavke_uplata(
    sue_id  number
    ,upa_id  number
    ,rcn_id number
    ,iznos_uplate number(9,2) not null
    ,constraint sue_pk primary key (sue_id)
    ,constraint sue_upa_fk foreign key (upa_id)
    references uplate(upa_id)
    ,constraint sue_rcn_fk foreign key (rcn_id)
    references racuni(rcn_id)
    );
    
create table obracuni_zateznih(
    ozh_id  number
    ,broj_obracuna varchar2(20) not null unique
    ,datum_pokretanja date not null
    ,constraint ozh_pk primary key (ozh_id)
    );
    
create table stavke_obracuna(
    soa_id  number
    ,ozh_id number
    ,rcn_id number
    ,iznos_kamate number(9,2) not null
    ,constraint soa_pk primary key (soa_id)
    ,constraint soa_ozh_fk foreign key (ozh_id)
    references obracuni_zateznih(ozh_id)
    ,constraint soa_rcn_fk foreign key (rcn_id)
    references racuni(rcn_id)
    );

create sequence str_seq start with 1
	increment by 1;

create sequence pzd_seq start with 1
	increment by 1;

create sequence rcn_seq start with 1
	increment by 1;
  
create sequence sra_seq start with 1
	increment by 1;
  
create sequence upa_seq start with 1
	increment by 1;

create sequence sue_seq start with 1
	increment by 1;

create sequence ozh_seq start with 1
	increment by 1;
  
create sequence soa_seq start with 1
	increment by 1;


insert into stranke values(
    str_seq.nextval,'Kon99','Konzum');
insert into stranke values(
    str_seq.nextval,'In44','In2');
insert into stranke values(
    str_seq.nextval,'Fer303','Fer');
insert into stranke values(
    str_seq.nextval,'Po92','Privatna Osoba');
    
insert into proizvodi values(
    pzd_seq.nextval,'Mrk45','Mrkvica',4.99);
insert into proizvodi values(
    pzd_seq.nextval,'Pri19','Pringles',19.5);
insert into proizvodi values(
    pzd_seq.nextval,'Mzm21','Maska za mobitel',21);
insert into proizvodi values(
    pzd_seq.nextval,'Knj35','Knjiga',35.5);
insert into proizvodi values(
    pzd_seq.nextval,'Scp11','Super cool prozvod',112);
insert into proizvodi values(
    pzd_seq.nextval,'Mrc85','Mercedes igraèka',85);