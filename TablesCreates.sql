create database Controle_Alunos;

use Controle_Alunos;

create table Aluno(
ra varchar(10) not null,
cpf varchar(14) not null,
nome varchar(50) not null,
dnascimento date not null,
cep varchar(9) not null,

constraint PK_Aluno primary key (ra),
);

create table Disciplina(
codigo int not null identity,
sigla varchar(5) not null,
nome varchar(50) not null,
totalhoras int not null,

constraint PK_Disciplina primary key (codigo),

unique(sigla)
);

create table Situacao(
codigo int not null identity,
descricao varchar(50),

constraint PK_Situacao primary key (codigo),
);

create table Matricula(
ano int not null,
semestre int not null,
nota1 float null,
nota2 float null,
media float null,
substitutiva float null,
horasfaltas int not null,
ra_aluno varchar(10) not null,
codigo_disciplina int not null,
codigo_situacao int not null,

constraint PK_Matricula primary key (ano,semestre,ra_aluno,codigo_disciplina),--assim um aluno pode ter varias matriculas porem nao
--pode ter a mesma matricula na mesma disciplina no mesmo ano e e mesmo semestre

constraint FK_MatriculaAluno foreign key (ra_aluno) references Aluno(ra),
constraint FK_MatriculaDisciplina foreign key (codigo_disciplina) references Disciplina(codigo),
constraint FK_MatriculaSituacao foreign key (codigo_situacao) references Situacao(codigo)
);