select sifra, naziv, jed_cijena, count(pzd_id) as "Broj pojavljivanja"
	from proizvodi join stavke_racuna
		using(pzd_id)
	group by sifra, naziv, jed_cijena
	having count(pzd_id) = (select max(count(pzd_id))                       
				from stavke_racuna                     
				group by pzd_id);