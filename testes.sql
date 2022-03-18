  --testes
  update Matricula set codigo_situacao = 1 where ano = 2021 and semestre = 1 and ra_aluno = '04721-006' and codigo_disciplina = 3
  update Matricula set horasfaltas = 0 where ano = 2021 and semestre = 1 and ra_aluno = '04721-006' and codigo_disciplina = 3
  update Matricula set nota1 = 3, nota2 = 2 where ano = 2021 and semestre = 1 and ra_aluno = '04721-006' and codigo_disciplina = 5
  update Matricula set substitutiva = 4 where ano = 2021 and semestre = 1 and ra_aluno = '04721-006' and codigo_disciplina = 5

  --chamando as procedures
  exec.dbo.DisciplinaAlunos 1, 2021 --disciplina e ano
  exec.dbo.BoletimAlunoDisciplinas '04721-006', 2021, 1 --ra, ano e semestre
  exec.dbo.ReprovadosNotas 2021--apenas o ano