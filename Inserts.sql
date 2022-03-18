use Controle_Alunos;

insert into Situacao values
('CURSANDO'),
('REPROVADO POR NOTA'),
('REPROVADO POR FALTA'),
('CURSO TRANCADO'),
('APROVADO')

insert into Aluno values
('04721-006','518.803.458-11','Fabio Zenatti Ferrenha',      '2002/08/31','14806-160'),
('04753-026','080.492.322-12','Andreia Jéssica Heloise Lima','1970/02/19','79602-042'),
('04893-032','205.063.031-01','Fábio Henry Barros',          '1987/01/04','79062-410'),
('04027-032','543.220.516-50','Marcela Mariana Pires',       '1999/01/14','25080-200')

insert into Disciplina values
('BDI',  'Banco de Dados I',                   100),
('BDIi', 'Banco de Dados Ii',                  100),
('CCLI', 'Calculo I',                          50),
('CCLII','Calculo II',                         50),
('AMPI', 'Arquitetura de Micoprocessadores I', 50),
('AMPII','Arquitetura de Micoprocessadores II',50),
('EEC',  'Ética e Cidadania                  ',50)

insert into Matricula (ano,semestre,horasfaltas,ra_aluno,codigo_disciplina,codigo_situacao) values
(2021,1,0,'04721-006',3,1),
(2021,2,0,'04753-026',1,1),
(2021,1,0,'04721-006',5,1),
(2021,2,0,'04753-026',7,1),
(2021,2,0,'04027-032',1,1)
