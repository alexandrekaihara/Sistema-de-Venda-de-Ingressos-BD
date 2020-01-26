-- Ajustes:
-- Criar procedures do CRUD
-- Criar todas as views
-- Criar usuarios e as permissoes
-- Criar as trigger que impedem:
--      - deletar evento se tiver apresentação com ingresso vendido
--      - atualizar o cpf de um usuario;
-- Testar as procedures de insert
-- Testar procedures update
-- Inserir backup e recuperação do database


-- -----------------------------------------------------
-- Autores: 
--      - Alexandre Mitsuru Kaihara (18/0029690)
--      - João Pedro (18/00......)
-- Disciplina: Bancos de Dados
--
-- Palavras-chave para busca:
-- (0.0) - Database bancosdedados2020
-- (0.1) - Schema venda_ingressos
-- (1.0) - Create Tables
--      (1.1) - Table Usuario
--      (1.2) - Table CartaoCredito
--      (1.3) - Table Evento
--      (1.4) - Table Apresentacao
--      (1.5) - Table Ingresso
-- (2.0) - Primary keys
-- (3.0) - Foreign keys
-- (4.0) - Views
-- (5.0) - Functions
--      (5.1) - Usuario Functions
--      (5.2) - CartaoCredito Functions
--      (5.3) - Evento Functions
--      (5.4) - Ingresso Functions
--      (5.5) - String Functions
-- (6.0) - Constraint
--      (6.1) - Usuario restrictions
--      (6.2) - CartaoCredito restrictions
--      (6.3) - Evento restrictions
--      (6.4) - Apresentacao restrictions
--      (6.5) - Ingresso restrictions
-- (7.0) - Procedures
--      (7.1) - Procedures Create        
--      (7.2) - Procedures Read
--      (7.3) - Procedures Update
--      (7.4) - Procedures Delete
-- (8.0) - Testes e debug
--      (8.1) - Restrict do DELETE de um CPF com referencia
--      (8.2) - Cascade do Código de Evento em Apresentacao
--      (8.3) - Teste dos restrictions Usuario
--      (8.4) - Teste dos restrictions Apresentacao
--      (8.5) - Teste dos restrictions Evento
-- (9.0) - Create Users
-- -----------------------------------------------------



-- -----------------------------------------------------
-- (0.0) - Database bancosdedados2020
-- -----------------------------------------------------
    DROP DATABASE bancosdedados2020;
    CREATE DATABASE bancosdedados2020 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';
    ALTER DATABASE  bancosdedados2020 OWNER TO postgres;
    \c bancosdedados2020



-- -----------------------------------------------------
-- (0.1) - Schema venda_ingressos
-- -----------------------------------------------------
    CREATE SCHEMA venda_ingressos AUTHORIZATION postgres;
    SET search_path TO venda_ingressos, public;



-- -----------------------------------------------------
-- (1.0) - Create Tables
-- -----------------------------------------------------
-- -----------------------------------------------------
-- (1.1) - Table Usuario
-- -----------------------------------------------------
    CREATE TABLE IF NOT EXISTS Usuario(
        idCPF               CHAR   (11) NOT NULL,
        Senha               VARCHAR( 6) NOT NULL,
        DatadeNascimento    DATE NOT NULL);

    ALTER TABLE Usuario OWNER TO postgres;

    ALTER TABLE Usuario SET SCHEMA venda_ingressos;

-- -----------------------------------------------------
-- (1.2) - Table CartaoCredito
-- -----------------------------------------------------
    CREATE TABLE IF NOT EXISTS CartaoCredito (
        idNumeroCartaoCredito CHAR(16)  NOT NULL,
        DataValidade          CHAR( 4)  NOT NULL,
        CodigoSeguranca       SMALLINT  NOT NULL,
        fkCPF                 CHAR(14)  NOT NULL);

    ALTER TABLE CartaoCredito OWNER TO   postgres;

    ALTER TABLE CartaoCredito SET SCHEMA venda_ingressos;

-- -----------------------------------------------------
-- (1.3) - Table Evento
-- -----------------------------------------------------
    CREATE TABLE IF NOT EXISTS Evento (
        idCodigoEvento        BIGSERIAL,
        fkCPF                 CHAR(11) NOT NULL,
        NomeEvento            VARCHAR(19) NOT NULL,
        Cidade                VARCHAR(16) NOT NULL,
        FaixaEtaria           VARCHAR( 2) NOT NULL,
        Estado                CHAR   ( 2) NOT NULL,
        ClasseEvento          SMALLINT);

    ALTER TABLE Evento OWNER TO   postgres;

    ALTER TABLE Evento SET SCHEMA venda_ingressos;

-- -----------------------------------------------------
-- (1.4) - Table Apresentacao
-- -----------------------------------------------------
    CREATE TABLE IF NOT EXISTS Apresentacao (
        idCodigoApresentacao  BIGSERIAL,
        fkCodigoEvento        INT   NOT NULL,
        Preco                 FLOAT NOT NULL, 
        DataHorario           TIMESTAMP NOT NULL,
        NumeroSala            SMALLINT  NOT NULL,
        Disponibilidade       SMALLINT  NOT NULL);

    ALTER TABLE Apresentacao OWNER TO   postgres;

    ALTER TABLE Apresentacao SET SCHEMA venda_ingressos;

-- -----------------------------------------------------
-- (1.5) - Table Ingresso
-- -----------------------------------------------------
    CREATE TABLE IF NOT EXISTS Ingresso (
        idCodigoIngresso      BIGSERIAL,
        fkCodigoApresentacao  INT NOT NULL,
        fkCPF                 CHAR(11) NOT NULL,
        Quantidade            SMALLINT NOT NULL);

    ALTER TABLE Ingresso OWNER TO postgres;

    ALTER TABLE Ingresso SET SCHEMA venda_ingressos;



-- -----------------------------------------------------
-- (2.0) - Primary keys
-- -----------------------------------------------------
    ALTER TABLE ONLY Usuario 
    ADD CONSTRAINT pkCPF                 PRIMARY KEY (                idCPF);

    ALTER TABLE ONLY CartaoCredito 
    ADD CONSTRAINT pkNumeroCartaoCredito PRIMARY KEY (idNumeroCartaoCredito);

    ALTER TABLE ONLY Evento 
    ADD CONSTRAINT pkCodigoEvento        PRIMARY KEY (       idCodigoEvento);

    ALTER TABLE ONLY Apresentacao 
    ADD CONSTRAINT pkCodigoApresentacao  PRIMARY KEY ( idCodigoApresentacao);

    ALTER TABLE ONLY Ingresso 
    ADD CONSTRAINT pkCodigoIngresso      PRIMARY KEY (     idCodigoIngresso);



-- -----------------------------------------------------
-- (3.0) - Foreign keys
-- -----------------------------------------------------
    ALTER TABLE ONLY CartaoCredito
    ADD CONSTRAINT fkCPF FOREIGN KEY (fkCPF) 
    REFERENCES     Usuario(idCPF)
    ON UPDATE      RESTRICT;

    ALTER TABLE ONLY Evento
    ADD CONSTRAINT fkCPF FOREIGN KEY (fkCPF) 
    REFERENCES     Usuario(idCPF)
    ON DELETE RESTRICT;
    
    ALTER TABLE ONLY Apresentacao
    ADD CONSTRAINT fkCodigoEvento FOREIGN KEY (fkCodigoEvento) 
    REFERENCES     Evento(idCodigoEvento)
    ON UPDATE      CASCADE;

    ALTER TABLE ONLY Ingresso
    ADD CONSTRAINT fkCodigoApresentacao FOREIGN KEY (fkCodigoApresentacao) 
    REFERENCES     Apresentacao(idCodigoApresentacao)
    ON UPDATE      CASCADE 
    ON DELETE      RESTRICT;

    ALTER TABLE ONLY Ingresso
    ADD CONSTRAINT fkCPF FOREIGN KEY (fkCPF) 
    REFERENCES     Usuario(idCPF)
    ON DELETE      RESTRICT;



-- -----------------------------------------------------
-- (4.0) - Views
-- -----------------------------------------------------

    CREATE OR REPLACE VIEW ShowUsuario 
    AS SELECT * FROM Usuario;

    CREATE OR REPLACE VIEW ShowCartaoCredito 
    AS SELECT * FROM CartaoCredito;

    CREATE OR REPLACE VIEW ShowEvento 
    AS SELECT * FROM Evento;

    CREATE OR REPLACE VIEW ShowApresentacao 
    AS SELECT * FROM Apresentacao;

    CREATE OR REPLACE VIEW ShowIngresso
    AS SELECT * FROM Ingresso;



-- -----------------------------------------------------
-- (5.0) - Functions
-- -----------------------------------------------------
-- -----------------------------------------------------
-- (5.1) - Usuario Functions
-- -----------------------------------------------------
    CREATE OR REPLACE OR REPLACE FUNCTION ValidarCPF(CPF CHAR(11)) RETURNS BOOLEAN
    LANGUAGE plpgsql
    AS $$
    DECLARE
        CPFcharacter VARCHAR(1) := SUBSTRING(CPF FROM 1 FOR 1);
        Valido       BOOLEAN := FALSE;
        Digito       INTEGER := 0;
        Soma         INTEGER := 0;
        Indice       INTEGER := 1;
    BEGIN
    --Verifica de todos os dígitos não são repetidos
    WHILE (Indice <= 9)   
    LOOP
        IF (SUBSTRING(CPF FROM Indice FOR 1) <> CPFcharacter) THEN
            Valido = TRUE;
        END IF;
        Indice = Indice + 1;
    END LOOP;

    -- Verificação da validade do primeiro dígito
    IF (Valido = TRUE) THEN
        Indice = 1;

        WHILE (Indice <= 9)
        LOOP
            Soma = Soma + TO_NUMBER(SUBSTRING(CPF FROM Indice FOR 1), '9') * (11 - Indice);
            Indice = (Indice + 1);
        END LOOP; 

        Digito = 11 - (Soma % 11);
        IF (Digito > 9) THEN 
            Digito = 0;
        END IF;

        IF (Digito <> TO_NUMBER(SUBSTRING(CPF FROM 10 FOR 1), '9')) THEN
            Valido = FALSE;
        END IF;
    END IF;

    IF(Valido = TRUE) THEN
        Indice = 1;
        Soma   = 0;

        WHILE (Indice <= 10)
        LOOP
            Soma = Soma + TO_NUMBER(SUBSTRING(CPF FROM Indice FOR 1), '9') * (12 - Indice);
            Indice = Indice + 1;
        END LOOP; 

        Digito = 11 - (Soma % 11);
        IF (Digito > 9) THEN 
            Digito = 0;
        END IF;

        IF (Digito <> TO_NUMBER(SUBSTRING(CPF FROM 11 FOR 1), '9')) THEN
            Valido = FALSE;
        END IF;
    END IF;

    RETURN Valido;
    END $$;

    CREATE OR REPLACE FUNCTION ValidarSenha(Senha VARCHAR(6)) RETURNS BOOLEAN
    LANGUAGE plpgsql
    AS $$
    DECLARE
        TamanhoSenha INTEGER := CHAR_LENGTH (Senha);
        Indice       INTEGER := 1;
        Indice2      INTEGER := 2;
        Valido BOOLEAN := FALSE;
        TemUPC BOOLEAN := FALSE;
        TemLWC BOOLEAN := FALSE;
        TemDIG BOOLEAN := FALSE;
        Caractere CHAR(1);
    BEGIN
    -- Verifica se há pelo menos o mínimo de caracteres
    IF (CHAR_LENGTH(Senha)) >= 3 THEN
        Valido = TRUE;
    END IF;

    -- Verifica se tem um upper case, um lower case e um número pelo menos
    IF (VALIDO = TRUE) THEN
        WHILE (Indice <= TamanhoSenha)
        LOOP
            Caractere = SUBSTRING(Senha, Indice, 1);
            CASE WHEN (Is_digit(Caractere)) THEN TemDIG = TRUE;
                WHEN (Is_upper(Caractere)) THEN TemUPC = TRUE;
                WHEN (Is_lower(Caractere)) THEN TemLWC = TRUE;
                ELSE Valido = FALSE;
            END CASE;
            Indice = Indice + 1;
        END LOOP;
    END IF;

    -- Verifica se não há caracteres repetidos
    IF (TemDIG AND TemUPC AND TemLWC AND Valido) THEN
        Indice = 1;
        WHILE (Indice < TamanhoSenha)
        LOOP
            Caractere = SUBSTRING (Senha FROM Indice FOR 1);
            WHILE (Indice2 <= TamanhoSenha)
            LOOP
                IF(Caractere = SUBSTRING(Senha FROM Indice2 FOR 1)) THEN
                    Valido = FALSE;
                END IF;
                Indice2 = Indice2 + 1;
            END LOOP;
            Indice  = Indice + 1;
            Indice2 = Indice + 2;
        END LOOP;
    ELSE
        Valido = FALSE;
    END IF;

    RETURN Valido;
    END $$;

-- -----------------------------------------------------
-- (5.2) - CartaoCredito Functions
-- -----------------------------------------------------
    CREATE OR REPLACE FUNCTION ValidarNumeroCartaoCredito(NumeroCartaoCredito CHAR(16)) RETURNS BOOLEAN
    LANGUAGE plpgsql
    AS $$
    DECLARE
        Valido BOOLEAN := FALSE;
        Digito INTEGER := TO_NUMBER(SUBSTRING(NumeroCartaoCredito FROM 16 FOR 1), '9');
        Soma   INTEGER := 0;
        AuxInt INTEGER := 0;
        Indice INTEGER := 1;
    BEGIN
    WHILE (Indice <= 15)
    LOOP
        AuxInt = TO_NUMBER(SUBSTRING(NumeroCartaoCredito FROM Indice FOR 1), '9');
        IF (Indice % 2 = 0) THEN
            AuxInt = AuxInt * 2;
        END IF;  
        IF(AuxInt > 9) THEN
            AuxInt = AuxInt % 10 + FLOOR(AuxInt / 10);
        END IF;
        Soma = Soma + AuxInt;
        Indice = Indice + 1;
    END LOOP;
    IF(Digito = ((Soma * 9) % 10)) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
    END $$;

    CREATE OR REPLACE FUNCTION ValidarValidade(Validade VARCHAR(4)) RETURNS BOOLEAN
    LANGUAGE plpgsql
    AS $$
    DECLARE
        Mes INTEGER := TO_NUMBER (SUBSTRING(Validade FROM 1 FOR 2), '99');
    BEGIN
    IF (Mes >= 1 AND Mes <= 12) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
    END $$;

-- -----------------------------------------------------
-- (5.3) - Evento Functions
-- -----------------------------------------------------
    CREATE OR REPLACE FUNCTION ValidarNomeEvento(NomeEvento VARCHAR(19)) RETURNS BOOLEAN
    LANGUAGE plpgsql
    AS $$
    DECLARE
        Caractere   CHAR(1);
        doisEspacos BOOLEAN := FALSE;
        TemLetra    BOOLEAN := FALSE;
        Valido      BOOLEAN :=  TRUE;
        NomeTamn    INTEGER := CHAR_LENGTH (NomeEvento);
        Indice      INTEGER := 1;
        Is_space    INTEGER := 0;
    BEGIN
    WHILE (Indice <= NomeTamn)
    LOOP
        Caractere = SUBSTRING (NomeEvento FROM Indice FOR 1);
        IF (Valido) THEN
            CASE WHEN (ASCII(Caractere) = Is_space) THEN
                -- Verifica se há dois espaços repetidos
                IF(doisEspacos) THEN
                    Valido = FALSE;
                ELSE
                    doisEspacos = TRUE;
                END IF;
            WHEN (Is_lower(Caractere) OR Is_upper(Caractere)) THEN
                -- Quando é uma letra
                TemLetra    =  TRUE;
                doisEspacos = FALSE;
            WHEN (Is_digit(Caractere)) THEN
                doisEspacos = FALSE;
            ELSE 
                Valido = FALSE;
            END CASE;
        END IF;
        Indice = Indice + 1;
    END LOOP;

    IF (Valido AND TemLetra) THEN
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;
    END $$;

    CREATE OR REPLACE FUNCTION ValidarCidade(Cidade VARCHAR(16)) RETURNS BOOLEAN
    LANGUAGE plpgsql
    AS $$
    DECLARE
        Caractere   CHAR(1);
        doisEspacos BOOLEAN := FALSE;
        TemLetra    BOOLEAN := FALSE;
        TemPonto    BOOLEAN := FALSE;
        Valido      BOOLEAN :=  TRUE;
        NomeTamn    INTEGER := CHAR_LENGTH (Cidade);
        Indice      INTEGER :=  1;
        Is_space    INTEGER :=  0;
        Is_ponto    INTEGER := 46;
    BEGIN
    WHILE (Indice <= NomeTamn)
    LOOP
        Caractere = SUBSTRING (Cidade FROM Indice FOR 1);
        IF (Valido) THEN    
            CASE WHEN (TemPonto) THEN
                IF (Is_lower(Caractere) = FALSE AND Is_upper(Caractere) = FALSE) THEN
                    Valido = FALSE;
                ELSE 
                    TemPonto = FALSE;
                END IF;
            WHEN (ASCII(Caractere) = Is_ponto) THEN
                TemPonto = TRUE;
            WHEN (ASCII(Caractere) = Is_space) THEN
                -- Verifica se há dois espaços repetidos
                IF(doisEspacos) THEN
                    Valido = FALSE;
                ELSE
                    doisEspacos = TRUE;
                END IF;
                TemPonto = FALSE;
            WHEN (Is_lower(Caractere) OR Is_upper(Caractere)) THEN
                -- Quando é uma letra
                TemLetra    =  TRUE;
                doisEspacos = FALSE;
                TemPonto    = FALSE;
            WHEN (Is_digit(Caractere)) THEN
                doisEspacos = FALSE;
                TemPonto    = FALSE;
            ELSE 
                Valido = FALSE;
            END CASE;
        END IF;
        Indice = Indice + 1;
    END LOOP;

    IF (Valido AND TemLetra) THEN
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;
    END $$;

    CREATE OR REPLACE FUNCTION ValidarEstado(Estado CHAR(2)) RETURNS BOOLEAN
    LANGUAGE plpgsql
    AS $$
    DECLARE
        Estados CHAR(2)[26] := ARRAY['AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 
                                'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 
                                'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS',
                                'RO', 'RR', 'SC', 'SE', 'TO'];
    BEGIN
    IF (ARRAY[Estado] <@ Estados) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
    END $$;

    CREATE OR REPLACE FUNCTION ValidarFaixaEtaria(FaixaEtaria VARCHAR(2)) RETURNS BOOLEAN
    LANGUAGE plpgsql
    AS $$
    DECLARE
        FaixasEtarias VARCHAR(2)[26] := ARRAY['L', '10', '12', '14', '16', '18'];
    BEGIN
    IF (ARRAY[FaixaEtaria] <@ FaixasEtarias) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
    END $$;

-- -----------------------------------------------------
-- (5.4) - Ingresso Functions
-- -----------------------------------------------------

    CREATE OR REPLACE FUNCTION VerificarDisponibilidade () RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $disp$
    DECLARE 
        QtdDisponivel INTEGER := (SELECT Disponibilidade FROM Apresentacao WHERE NEW.fkCodigoApresentacao = idCodigoApresentacao) - NEW.Quantidade;
    BEGIN
    IF (QtdDisponivel >= 0) THEN
        UPDATE Apresentacao SET Disponibilidade = QtdDisponivel WHERE NEW.fkCodigoApresentacao = idCodigoApresentacao;
    ELSE 
        RAISE EXCEPTION 'Quantidade requerida nao disponivel';
    END IF;

    RETURN NEW;
    END $disp$;

-- -----------------------------------------------------
-- (5.5) - String Functions
-- -----------------------------------------------------
    CREATE OR REPLACE FUNCTION Is_upper (Caractere CHAR(1)) RETURNS BOOLEAN
    LANGUAGE plpgsql
    AS $$
    BEGIN
    IF (ASCII(Caractere) >= 65 AND ASCII(Caractere) <= 90) THEN
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;
    END $$;

    CREATE OR REPLACE FUNCTION Is_lower (Caractere CHAR(1)) RETURNS BOOLEAN
    LANGUAGE plpgsql
    AS $$
    BEGIN
    IF (ASCII(Caractere) >= 97 AND ASCII(Caractere) <= 122) THEN
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;
    END $$;

    CREATE OR REPLACE FUNCTION Is_digit (Caractere CHAR(1)) RETURNS BOOLEAN
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF (ASCII(Caractere) >= 48 AND ASCII(Caractere) <= 57) THEN
            RETURN TRUE;
        ELSE 
            RETURN FALSE;
        END IF;
    END $$;



-- -----------------------------------------------------
-- (6.0) - Restrictions
-- -----------------------------------------------------
-- -----------------------------------------------------
-- (6.1) - Usuario restrictions
-- -----------------------------------------------------
    ALTER TABLE Usuario 
    ADD CONSTRAINT cValidarCPF 
    CHECK (ValidarCPF(idCPF));

    ALTER TABLE Usuario 
    ADD CONSTRAINT cValidarSenha 
    CHECK (ValidarSenha(Senha));

-- -----------------------------------------------------
-- (6.2) - CartaoCredito restrictions
-- -----------------------------------------------------
    ALTER TABLE      CartaoCredito
    ADD CONSTRAINT cValidarNumeroCartaoCredito 
    CHECK          (ValidarNumeroCartaoCredito(idNumeroCartaoCredito));

    ALTER TABLE      CartaoCredito
    ADD CONSTRAINT cValidarValidade 
    CHECK          (ValidarValidade(DataValidade));

    ALTER TABLE      CartaoCredito
    ADD CONSTRAINT cValidarCodigoSeguranca 
    CHECK          (CodigoSeguranca >= 0 AND CodigoSeguranca <= 999);

-- -----------------------------------------------------
-- (6.3) - Evento restrictions
-- -----------------------------------------------------
    ALTER TABLE      Evento
    ADD CONSTRAINT cValidaridCodigoEvento 
    CHECK          (idCodigoEvento >= 0 AND idCodigoEvento <= 999);

    ALTER TABLE      Evento
    ADD CONSTRAINT cValidarNomeEvento 
    CHECK          (ValidarNomeEvento(NomeEvento));

    ALTER TABLE      Evento
    ADD CONSTRAINT cValidarCidade 
    CHECK          (ValidarCidade(Cidade));

    ALTER TABLE      Evento
    ADD CONSTRAINT cValidarEstado
    CHECK          (ValidarEstado(Estado));

    ALTER TABLE      Evento
    ADD CONSTRAINT cValidarFaixaEtaria 
    CHECK          (ValidarFaixaEtaria(FaixaEtaria));

    ALTER TABLE      Evento
    ADD CONSTRAINT cValidarClasseEvento 
    CHECK          (ClasseEvento >= 1 AND ClasseEvento <= 4);

-- -----------------------------------------------------
-- (6.4) - Apresentacao restrictions
-- -----------------------------------------------------
    ALTER TABLE      Apresentacao
    ADD CONSTRAINT cValidaridCodigoApresentacao 
    CHECK          (idCodigoApresentacao > -1 AND idCodigoApresentacao < 10000);

    ALTER TABLE      Apresentacao
    ADD CONSTRAINT cValidarPreco 
    CHECK          (Preco >= 0 AND Preco <= 1000);

    ALTER TABLE      Apresentacao
    ADD CONSTRAINT cValidarNumeroSala 
    CHECK          (NumeroSala >= 0 AND NumeroSala <= 10);

    ALTER TABLE      Apresentacao
    ADD CONSTRAINT cValidarDisponibilidade 
    CHECK          (Disponibilidade >= 0 AND Disponibilidade <= 250);

-- -----------------------------------------------------
-- (6.5) - Ingresso restrictions
-- -----------------------------------------------------
    ALTER TABLE      Ingresso
    ADD CONSTRAINT cValidaridCodigoIngresso 
    CHECK          (idCodigoIngresso >= 0 AND idCodigoIngresso <= 99999);

    CREATE TRIGGER   tValidarQuantidade
    BEFORE INSERT ON Ingresso
    FOR EACH ROw
    EXECUTE PROCEDURE VerificarDisponibilidade();



-- -----------------------------------------------------
-- (7.0) - Procedures
-- -----------------------------------------------------
-- -----------------------------------------------------
-- (7.1) - Procedures Create        
-- -----------------------------------------------------
    CREATE OR REPLACE PROCEDURE CriarUsuario (CPF CHAR(11), Senha CHAR(6), DataNascimento DATE)
    LANGUAGE plpgsql
    AS $insertusuario$
    BEGIN
    INSERT INTO Usuario VALUES (CPF, Senha, DataNascimento); 
    END $insertusuario$;

    CREATE OR REPLACE PROCEDURE CriarCartaoCredito (NumeroCartaoCredito CHAR(16), DataValidade CHAR(4), CodigoSeguranca SMALLINT, fkCPF CHAR(11))
    LANGUAGE plpgsql
    AS $insertcartaocredito$
    BEGIN
    INSERT INTO CartaoCredito VALUES (NumeroCartaoCredito, DataValidade, CodigoSeguranca, fkCPF); 
    END $insertcartaocredito$;

    CREATE OR REPLACE PROCEDURE CriarEvento (fkCPF CHAR(11), NomeEvento CHAR(19), Cidade CHAR(16), FaixaEtaria VARCHAR(2), Estado CHAR(2), ClasseEvento SMALLINT)
    LANGUAGE plpgsql
    AS $insertevento$
    BEGIN
    INSERT INTO Evento (fkCPF, NomeEvento, Cidade, FaixaEtaria, Estado, ClasseEvento) VALUES (fkCPF, NomeEvento, Cidade, FaixaEtaria, Estado, ClasseEvento); 
    END $insertevento$;

    CREATE OR REPLACE PROCEDURE CriarApresentacao (fkCodigoEvento INTEGER, Preco SMALLINT, DataHorario TIMESTAMP, NumeroSala SMALLINT, Disponibilidade SMALLINT)
    LANGUAGE plpgsql
    AS $insertapresentacao$
    BEGIN
    INSERT INTO Apresentacao (fkCodigoEvento, Preco, DataHorario, NumeroSala, Disponibilidade) VALUES (fkCodigoEvento, Preco, DataHorario, NumeroSala, Disponibilidade); 
    END $insertapresentacao$;

    CREATE OR REPLACE PROCEDURE CriarIngresso (fkCodigoApresentacao  INTEGER, fkCPF CHAR(11), Quantidade SMALLINT)
    LANGUAGE plpgsql
    AS $insertingresso$
    BEGIN
    INSERT INTO Ingresso (fkCodigoApresentacao, fkCPF, Quantidade) VALUES (fkCodigoApresentacao, fkCPF, Quantidade); 
    END $insertingresso$;

-- -----------------------------------------------------
-- (7.2) - Procedures Read
-- -----------------------------------------------------
-- -----------------------------------------------------
-- (7.3) - Procedures Update
-- -----------------------------------------------------
    CREATE OR REPLACE PROCEDURE UpdateUsuario (uOldCPF CHAR(11), uNewCPF CHAR(11), uSenha CHAR(6), uDatadeNascimento DATE)
    LANGUAGE plpgsql
    AS $updateusuario$
    BEGIN
    UPDATE Usuario SET idCPF = uNewCPF, Senha = uSenha, DatadeNascimento = uDatadeNascimento WHERE idCPF = uOldCPF; 
    END $updateusuario$;

    CREATE OR REPLACE PROCEDURE UpdateCartaoCredito (uOldNumeroCartaoCredito CHAR(16), uNewNumeroCartaoCredito CHAR(16), uDataValidade CHAR(4), uCodigoSeguranca SMALLINT, ufkCPF CHAR(11))
    LANGUAGE plpgsql
    AS $updatecartaocredito$
    BEGIN
    UPDATE CartaoCredito SET NumeroCartaoCredito = uNewNumeroCartaoCredito, DataValidade = uDataValidade, CodigoSeguranca = uCodigoSeguranca, fkCPF = ufkCPF WHERE NumeroCartaoCredito = uOldNumeroCartaoCredito; 
    END $updatecartaocredito$;

    CREATE OR REPLACE PROCEDURE UpdateEvento (uOldidCodigoEvento INTEGER, uNewidCodigoEvento INTEGER, fkCPF CHAR(11), NomeEvento CHAR(19), Cidade CHAR(16), FaixaEtaria VARCHAR(2), Estado CHAR(2), ClasseEvento SMALLINT)
    LANGUAGE plpgsql
    AS $updateevento$
    BEGIN
    UPDATE Evento SET idCodigoEvento = uNewidCodigoEvento, fkCPF = ufkCPF, NomeEvento = uNomeEvento, Cidade = uCidade, FaixaEtaria = uFaixaEtaria, Estado = uEstado, ClasseEvento = uClasseEvento WHERE idCodigoEvento = uOldidCodigoEvento;
    END $updateevento$;

    CREATE OR REPLACE PROCEDURE UpdateApresentacao (uOldidCodigoApresentacao INTEGER, uNewidCodigoApresentacao INTEGER, ufkCodigoEvento INTEGER, uPreco SMALLINT, uDataHorario TIMESTAMP, uNumeroSala SMALLINT, uDisponibilidade SMALLINT)
    LANGUAGE plpgsql
    AS $updateapresentacao$
    BEGIN
    UPDATE Apresentacao SET idCodigoApresentacao = uNewidCodigoApresentacao,  fkCodigoEvento = ufkCodigoEvento, Preco = uPreco, DataHorario = uDataHorario, NumeroSala = uNumeroSala, Disponibilidade = uDisponibilidade WHERE idCodigoApresentacao = uOldidCodigoApresentacao; 
    END $updateapresentacao$;

    CREATE OR REPLACE PROCEDURE UpdateIngresso (uOldidCodigoIngresso INTEGER, uNewidCodigoIngresso INTEGER, ufkCodigoApresentacao  INTEGER, ufkCPF CHAR(11), uQuantidade SMALLINT)
    LANGUAGE plpgsql
    AS $updateingresso$
    BEGIN
    UPDATE Ingresso SET idCodigoIngresso = uNewidCodigoIngresso, fkCodigoApresentacao = ufkCodigoApresentacao, fkCPF = ufkCPF, Quantidade = uQuantidade WHERE idCodigoIngresso = uOldidCodigoIngresso; 
    END $updateingresso$;

-- -----------------------------------------------------
-- (7.4) - Procedures Delete
-- -----------------------------------------------------
    CREATE OR REPLACE PROCEDURE DeleteUsuario (uCPF CHAR(11), uSenha CHAR(6), uDatadeNascimento DATE)
    LANGUAGE plpgsql
    AS $deleteusuario$
    BEGIN
    DELETE FROM Usuario WHERE idCPF = uCPF AND Senha = uSenha AND DatadeNascimento = uDatadeNascimento; 
    END $deleteusuario$;

    CREATE OR REPLACE PROCEDURE DeleteCartaoCredito (uNumeroCartaoCredito CHAR(16), uDataValidade CHAR(4), uCodigoSeguranca SMALLINT, ufkCPF CHAR(11))
    LANGUAGE plpgsql
    AS $deletecartaocredito$
    BEGIN
    DELETE FROM CartaoCredito WHERE NumeroCartaoCredito = uNumeroCartaoCredito AND DataValidade = uDataValidade AND CodigoSeguranca = uCodigoSeguranca AND fkCPF = ufkCPF; 
    END $deletecartaocredito$;

    CREATE OR REPLACE PROCEDURE DeleteEvento (uidCodigoEvento INTEGER, fkCPF CHAR(11), NomeEvento CHAR(19), Cidade CHAR(16), FaixaEtaria VARCHAR(2), Estado CHAR(2), ClasseEvento SMALLINT)
    LANGUAGE plpgsql
    AS $deleteevento$
    BEGIN
    DELETE FROM Evento WHERE idCodigoEvento = uidCodigoEvento AND fkCPF = ufkCPF AND NomeEvento = uNomeEvento AND Cidade = uCidade AND FaixaEtaria = uFaixaEtaria AND Estado = uEstado AND ClasseEvento = uClasseEvento;
    END $deleteevento$;

    CREATE OR REPLACE PROCEDURE DeleteApresentacao (uidCodigoApresentacao INTEGER, ufkCodigoEvento INTEGER, uPreco SMALLINT, uDataHorario TIMESTAMP, uNumeroSala SMALLINT, uDisponibilidade SMALLINT)
    LANGUAGE plpgsql
    AS $deleteapresentacao$
    BEGIN
    DELETE FROM Apresentacao WHERE idCodigoApresentacao = uidCodigoApresentacao AND  fkCodigoEvento = ufkCodigoEvento AND Preco = uPreco AND DataHorario = uDataHorario AND NumeroSala = uNumeroSala AND Disponibilidade = uDisponibilidade; 
    END $deleteapresentacao$;

    CREATE OR REPLACE PROCEDURE DeleteIngresso (uidCodigoIngresso INTEGER, ufkCodigoApresentacao  INTEGER, ufkCPF CHAR(11), uQuantidade SMALLINT)
    LANGUAGE plpgsql
    AS $deleteingresso$
    BEGIN
    DELETE FROM Ingresso WHERE idCodigoIngresso = uidCodigoIngresso AND fkCodigoApresentacao = ufkCodigoApresentacao AND fkCPF = ufkCPF AND Quantidade = uQuantidade; 
    END $deleteingresso$;

-- -----------------------------------------------------
-- (8.0) - Testes e debug
-- -----------------------------------------------------
-- ----------------------------------------------------- 
-- (8.1) - Restrict do DELETE de um CPF com referencia
-- -----------------------------------------------------
    CALL CriarUsuario       ('03515226036', '1234aA', '19/01/20');
    CALL CriarCartaoCredito ('5467097237169470', '0120', '123', '05370637148');
    DELETE FROM Usuario WHERE idCPF = '05370637148';

-- ----------------------------------------------------- 
-- (8.2) - Cascade do Código de Evento em Apresentacao
-- -----------------------------------------------------
    CALL CriarUsuario ('05370637148', '1234aA', '19/01/20');
    CALL CriarEvento ('05370637148', 'Rock in Rio', 'Formosa', 'L', 'GO', 1)::SMALLINT;
    CALL CriarCartaoCredito (1, 1, 123, '19/01/20 19:00:00', 2, 150);
    UPDATE Evento SET idCodigoEvento = 2 WHERE idCodigoEvento = 1;
    SELECT * FROM Apresentacao WHERE idCodigoApresentacao = 1;

-- ----------------------------------------------------- 
-- (8.3) - Teste dos restrictions Usuario
-- -----------------------------------------------------
    -- Teste do validar CPF
    DELETE FROM Usuario;
    CALL CriarUsuario ('05370637148', '1234aA', '19/01/20'); -- CPF Valido
    CALL CriarUsuario ('05370637142', '1234aA', '19/01/20'); -- CPF Invalido
    SELECT * FROM Usuario;

    -- Teste do validar senha
    DELETE FROM Usuario;
    CALL CriarUsuario ('05370637148', '1234aA', '19/01/20'); -- CPF Valido
    CALL CriarUsuario ('05370637142', '12345A', '19/01/20'); -- CPF Invalido
    SELECT * FROM Usuario;

-- ----------------------------------------------------- 
-- (8.4) - Teste dos restrictions CartaoCredito
-- -----------------------------------------------------
    DELETE FROM CartaoCredito;
    CALL CriarCartaoCredito ('5467097237169470', '0299', 999, '05370637148');
    CALL CriarCartaoCredito ('5467097237169471', '0299', 999, '05370637148');
    SELECT * FROM CartaoCredito;

    DELETE FROM CartaoCredito;
    CALL CriarCartaoCredito ('5467097237169470', '0099', 999, '05370637148');
    CALL CriarCartaoCredito ('5467097237169470', '0299', 999, '05370637148');
    SELECT * FROM CartaoCredito;

-- ----------------------------------------------------- 
-- (8.5) - Teste dos restrictions Evento
-- -----------------------------------------------------
    -- Verifica formato do nome do evento

    DELETE FROM Evento;
    CALL CriarEvento('05370637148', 'Rock in  Rio', 'Formosa', 'L', 'GO', 1::SMALLINT);
    CALL CriarEvento('05370637148', 'Rock in @Rio', 'Formosa', 'L', 'GO', 1::SMALLINT);
    CALL CriarEvento('05370637148', 'Rock in Rio' , 'Formosa', 'L', 'GO', 1::SMALLINT);
    SELECT * FROM Evento;

    -- Verifica a validade da cidade
    DELETE FROM Evento;
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa.2', 'L', 'GO', 1::SMALLINT);
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa@' , 'L', 'GO', 1::SMALLINT);
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa.a', 'L', 'GO', 1::SMALLINT);
    SELECT * FROM Evento;

    -- Verifica a validade da estado
    DELETE FROM Evento;
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa', 'L', 'Go', 1::SMALLINT);
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa', 'L', 'GA', 1::SMALLINT);
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa', 'L', 'GO', 1::SMALLINT);
    SELECT * FROM Evento;

    -- Verifica a validade da FaixaEtaria
    DELETE FROM Evento;
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa', ' A', 'GO', 1::SMALLINT);
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa', '11', 'GO', 1::SMALLINT);
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa', '12', 'GO', 1::SMALLINT);
    SELECT * FROM Evento;

-- ----------------------------------------------------- 
-- (8.6) - Teste dos restrictions Ingresso
-- -----------------------------------------------------
    DELETE FROM Ingresso;
    CALL CriarIngresso (1::SMALLINT, '05370637148', 151::SMALLINT);
    CALL CriarIngresso (1::SMALLINT, '05370637148', 150::SMALLINT);
    CALL CriarIngresso (1::SMALLINT, '05370637148',   1::SMALLINT);
    SELECT * FROM Ingresso;
    select * from Apresentacao;



-- -----------------------------------------------------
-- (9.0) - Create Users
-- ----------------------------------------------------- 
