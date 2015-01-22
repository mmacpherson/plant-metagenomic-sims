-- pull the largest SRA from each project
select s.Run_s
from sra_runs s
    left join sra_runs s2 on
    (s.BioProject_s = s2.BioProject_s and
    	s.Mbases_l <= s2.Mbases_l)
group by s.BioProject_s, s.Mbases_l
having count(*) <= 1
order by
s.BioProject_s, s.Mbases_l
;
