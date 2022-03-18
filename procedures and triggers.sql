--define a situacao com base nas notas 
create proc FazMediaSituacao @nota1 float ,@nota2 float, @substitutiva float, @ano int, @semestre int, @ra varchar(10),@cod_disciplina int
as
begin
	declare 
		@media float
	if isnull(@nota2,1) != 1 and isnull(@nota1,1) != 1
	begin
		if  isnull(@substitutiva, 1) = 1
		begin
			select @media = ((@nota1 + @nota2)/2)
			if @media <5
			begin 
				print 'Abaixo da media, necessita fazer a prova substitutiva'
			end

			if @media >=5
			begin
				print 'Aprovado'
				update Matricula set codigo_situacao = 5 where ano = @ano and semestre = @semestre and ra_aluno = @ra and codigo_disciplina = @cod_disciplina
			end
			update Matricula set media = @media where ano = @ano and semestre = @semestre and ra_aluno = @ra and codigo_disciplina = @cod_disciplina
		end

		if isnull(@substitutiva, 1) != 1
		begin
			if @nota1 < @nota2
			begin
				select @media = ((@substitutiva + @nota2)/2)
				if @media <5
				begin
					print 'Reprovado por nota'
					update Matricula set codigo_situacao = 2 where ano = @ano and semestre = @semestre and ra_aluno = @ra and codigo_disciplina = @cod_disciplina
				end
				if @media >=5
				begin
					print 'Aprovado'
					update Matricula set codigo_situacao = 5 where ano = @ano and semestre = @semestre and ra_aluno = @ra and codigo_disciplina = @cod_disciplina
				end
				update Matricula set media = @media where ano = @ano and semestre = @semestre and ra_aluno = @ra and codigo_disciplina = @cod_disciplina
			end

			if @nota1 >= @nota2
			begin
				select @media = ((@nota1 + @substitutiva)/2)
				if @media <5
				begin
					print 'Reprovado por nota'
					update Matricula set codigo_situacao = 2 where ano = @ano and semestre = @semestre and ra_aluno = @ra and codigo_disciplina = @cod_disciplina
				end
				if @media >=5
				begin
					print 'Aprovado'
					update Matricula set codigo_situacao = 5 where ano = @ano and semestre = @semestre and ra_aluno = @ra and codigo_disciplina = @cod_disciplina
				end
				update Matricula set media = @media where ano = @ano and semestre = @semestre and ra_aluno = @ra and codigo_disciplina = @cod_disciplina
			end
		end
	end
end;

--define a situacao com bse na frequencia
create proc FrequenciaSituacao @ano int, @semestre int, @ra varchar(10),@cod_disciplina int, @hfaltas int
as
begin
	declare
		@horas_disc int
	select @horas_disc = totalhoras from Disciplina where codigo = @cod_disciplina
	if @hfaltas > (0.25*@horas_disc)
	begin
		print'Reprovado por falta'
		update Matricula set codigo_situacao = 3 where ano = @ano and semestre = @semestre and ra_aluno = @ra and codigo_disciplina = @cod_disciplina
	end
end;

create trigger AlteraMatricula
on dbo.Matricula
after update
as
begin
	declare
		@ano int,
		@semestre int,
		@n1 float,
		@n2 float,
		@sub float,
		@ra varchar(10),
		@cod_disc int,
		@hfaltas int
	select
		@ano = inserted.ano,
		@semestre = inserted.semestre,
		@n1 = inserted.nota1,
		@n2 = inserted.nota2,
		@sub = inserted.substitutiva,
		@ra = inserted.ra_aluno,
		@cod_disc = inserted.codigo_disciplina,
		@hfaltas = inserted.horasfaltas
		from inserted 

	exec.dbo.FazMediaSituacao @n1, @n2, @sub, @ano, @semestre, @ra, @cod_disc--qualquer alteração da matricula ira verificar a situação de nota
	exec.dbo.FrequenciaSituacao @ano, @semestre, @ra, @cod_disc, @hfaltas--qualquer alteração da matricula ira verificar a situação de faltas

end;

--mostra todos oa alunos cadastrado em uma disciplina em um determinado ano
create proc DisciplinaAlunos @cod_disciplina int, @ano int
as
begin
	select ra_aluno,Aluno.nome as "nome do aluno",ano,nota1,nota2,media,substitutiva,horasfaltas,codigo_disciplina,Disciplina.nome as "nome da disciplina",codigo_situacao, Situacao.descricao as "Situacao"
	from Matricula join Situacao on Matricula.codigo_situacao = Situacao.codigo join Aluno on Matricula.ra_aluno = Aluno.ra join Disciplina on Matricula.codigo_disciplina = Disciplina.codigo 
	where codigo_disciplina = @cod_disciplina and ano = @ano
end;

--mostra o boletim de um aluno em todas as disciplinas matriculado em um determinado ano e semestre
create proc BoletimAlunoDisciplinas @ra_aluno varchar(10), @ano int, @semestre int
as
begin
	select ra_aluno,Aluno.nome as "nome do aluno",ano,semestre,nota1,nota2,media,substitutiva,horasfaltas,codigo_disciplina,Disciplina.nome as "nome da disciplina",Situacao.descricao as "Situacao"
	from Matricula join Situacao on Matricula.codigo_situacao = Situacao.codigo join Aluno on Matricula.ra_aluno = Aluno.ra join Disciplina on Matricula.codigo_disciplina = Disciplina.codigo
	where ra_aluno = @ra_aluno and ano = @ano and semestre = @semestre
end;

--mostra todos os alunos repovados por nota em um determinado ano em todas suas disciplinas
create proc ReprovadosNotas @ano int
as
begin
	select ra_aluno,Aluno.nome as "nome do aluno",codigo_disciplina,Disciplina.nome as "nome da disciplina",nota1,nota2,media,substitutiva 
	from Matricula join Aluno on Matricula.ra_aluno = Aluno.ra join Disciplina on Matricula.codigo_disciplina = Disciplina.codigo
	where ano = @ano and codigo_situacao = 2
end;
