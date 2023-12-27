-- Cria��o de um banco de dados referente a uma Construtora --
-- estudo de modelagem de banco por meio do SQL server --

CREATE DATABASE CONSTRUTORA;
GO
USE CONSTRUTORA;
GO
CREATE TABLE FUNCIONARIO(
	CODIGO INT NOT NULL IDENTITY,
	NOME VARCHAR(50) NOT NULL,
	CPF CHAR(11) NOT NULL,
	EMAIL VARCHAR(50) NOT NULL,
	DATA_NASCIMENTO DATE NOT NULL,
	SALARIO MONEY NOT NULL,
	SEXO CHAR(1) NOT NULL,
	CIDADE VARCHAR(50) NOT NULL,
	UF CHAR(2) NOT NULL,
	DATA_HORA_CADASTRO DATETIME NOT NULL DEFAULT GETDATE(),
	ATIVO BIT NOT NULL DEFAULT 1,
	CONSTRAINT PK_FUNCIONARIO PRIMARY KEY(CODIGO),
	CONSTRAINT UQ_FUNCIONARIO_CPF UNIQUE(CPF),
	CONSTRAINT UQ_FUNCIONARIO_EMAIL UNIQUE(EMAIL),
	CONSTRAINT CK_FUNCIONARIO_SEXO CHECK(SEXO IN('F','M')),
	CONSTRAINT CK_FUNCIONARIO_DATA_NASCIMENTO 
		CHECK(DATEDIFF(YEAR,DATA_NASCIMENTO,GETDATE())>=18),
	CONSTRAINT CK_FUNCIONARIO_CPF CHECK(LEN(CPF)=11)
);
GO
CREATE TABLE DEPENDENTE(
	CODIGO INT NOT NULL IDENTITY,
	NOME VARCHAR(50) NOT NULL,
	DATA_NASCIMENTO DATE NOT NULL,
	PARENTESCO VARCHAR(20) NOT NULL,
	COD_FUNCIONARIO INT NOT NULL,
	CONSTRAINT PK_DEPENDENTE PRIMARY KEY(CODIGO),
	CONSTRAINT FK_DEPENDENTE_FUNCIONARIO FOREIGN KEY(COD_FUNCIONARIO)
		REFERENCES FUNCIONARIO(CODIGO),
	CONSTRAINT CK_DEPENDENTE_DATA_NASCIMENTO 
		CHECK(DATEDIFF(YEAR,DATA_NASCIMENTO,GETDATE())<18)
);
GO
CREATE TABLE PROJETO(
	CODIGO INT NOT NULL IDENTITY,
	NOME VARCHAR(50) NOT NULL,
	DATA_INICIO DATE NOT NULL,
	DATA_TERMINO DATE NULL,
	VALOR MONEY NOT NULL,
	COD_FUNC_GER INT NOT NULL,
	CONSTRAINT PK_PROJETO PRIMARY KEY(CODIGO),
	CONSTRAINT FK_PROJETO_FUNCIONARIO FOREIGN KEY(COD_FUNC_GER)
		REFERENCES FUNCIONARIO(CODIGO),
	CONSTRAINT CK_PROJETO_DATA_TERMINO 
		CHECK(DATA_TERMINO IS NULL OR DATA_TERMINO>=DATA_INICIO)
);
GO
CREATE TABLE FUNCIONARIO_PROJETO(
	CODIGO INT NOT NULL IDENTITY,
	COD_FUNCIONARIO INT NOT NULL,
	COD_PROJETO INT NOT NULL,
	DATA_ENTRADA DATE NOT NULL,
	DATA_SAIDA DATE NULL,
	NUM_HORAS_TRAB FLOAT NOT NULL,
	CONSTRAINT PK_FUNCIONARIO_PROJETO PRIMARY KEY(CODIGO),
	CONSTRAINT FK_FUNCIONARIO_PROJETO_FUNCIONARIO FOREIGN KEY(COD_FUNCIONARIO)
		REFERENCES FUNCIONARIO(CODIGO),
	CONSTRAINT FK_FUNCIONARIO_PROJETO_PROJETO FOREIGN KEY(COD_PROJETO)
		REFERENCES PROJETO(CODIGO),
	CONSTRAINT CK_FUNCIONARIO_PROJETO_DATA_SAIDA 
		CHECK(DATA_SAIDA IS NULL OR DATA_SAIDA>=DATA_ENTRADA),
	CONSTRAINT CK_FUNCIONARIO_PROJETO_NUM_HORAS_TRAB CHECK(NUM_HORAS_TRAB>=0)
);