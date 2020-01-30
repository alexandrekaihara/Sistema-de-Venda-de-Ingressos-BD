-- PENDENCIAS(JOAO):
-- Elaborar melhores consultas de insert, read, update e delete 
-- Testar as procedures de insert
-- Testar procedures update
-- PENDENCIAS(Alexandre):
-- Criar todos os privilegios dos tres tipos de usarios
-- Inserir backup e recuperação do database


-- -----------------------------------------------------
-- Autores: 
--      - Alexandre Mitsuru Kaihara (18/0029690)
--      - João Pedro (18/00......)
-- Disciplina: Bancos de Dados
--
-- Palavras-chave para busca:
-- Database bancosdedados2020
-- (0.0) - Create Users
    -- (0.1) - Create Usuarios comuns
    -- (0.2) - Create Visitantes
    -- (0.3) - Create Administradores
-- (1.0) - Create Tables
    -- (1.1) - Table Usuario
    -- (1.2) - Table CartaoCredito
    -- (1.3) - Table Evento
    -- (1.4) - Table Apresentacao
    -- (1.5) - Table Ingresso
-- (2.0) - Primary keys
-- (3.0) - Foreign keys
-- (4.0) - Create policy
    -- (4.1) - Create policy Usuario
    -- (4.2) - Create policy CartaoCredito
    -- (4.3) - Create policy Evento
    -- (4.4) - Create policy Apresentacao
    -- (4.5) - Create policy Ingresso
-- (5.0) - Views
-- (6.0) - Functions
    -- (6.1) - Usuario Functions
    -- (6.2) - CartaoCredito Functions
    -- (6.3) - Evento Functions
    -- (6.4) - Apresentacao Functions
    -- (6.5) - Ingresso Functions
    -- (6.6) - String Functions
-- (7.0) - Constraint
    -- (7.1) - Usuario restrictions
    -- (7.2) - CartaoCredito restrictions
    -- (7.3) - Evento restrictions
    -- (7.4) - Apresentacao restrictions
    -- (7.5) - Ingresso restrictions
-- (8.0) - Procedures
    -- (8.1) - Procedures Create   
    -- (8.2) - Procedures Read
    -- (8.3) - Procedures Update
    -- (8.4) - Procedures Delete
-- (9.0) - Testes e debug
    -- (9.1) - Restrict do DELETE de um CPF com referencia
    -- (9.2) - Cascade do Código de Evento em Apresentacao
    -- (9.3) - Teste dos restrictions Usuario
    -- (9.4) - Teste dos restrictions Apresentacao
    -- (9.5) - Teste dos restrictions Evento
-- -----------------------------------------------------



-- -----------------------------------------------------
-- Database bancosdedados2020
-- -----------------------------------------------------
    DROP DATABASE bancosdedados2020;
    CREATE DATABASE bancosdedados2020 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';
    ALTER DATABASE  bancosdedados2020 OWNER TO postgres;
    \c bancosdedados2020

    CREATE SCHEMA venda_ingressos AUTHORIZATION postgres;
    SET search_path TO venda_ingressos, public;



-- -----------------------------------------------------
-- (0.0) - Create users
-- -----------------------------------------------------
-- -----------------------------------------------------
-- (0.1) - Create Usuarios comuns
-- ----------------------------------------------------- 

    CREATE ROLE LoginUsuario;

    GRANT CONNECT ON DATABASE bancosdedados2020 TO LoginUsuario;
    GRANT USAGE   ON SCHEMA   venda_ingressos   TO LoginUsuario;
    GRANT SELECT ON ALL TABLES IN SCHEMA venda_ingressos TO LoginUsuario;
    GRANT USAGE ON ALL SEQUENCES IN SCHEMA venda_ingressos TO LoginUsuario;
    GRANT INSERT ON CartaoCredito, Evento, Apresentacao, Ingresso TO LoginUsuario;
    GRANT UPDATE ON CartaoCredito, Evento, Apresentacao, Ingresso TO LoginUsuario;
    GRANT DELETE ON CartaoCredito, Evento, Apresentacao, Ingresso TO LoginUsuario;

-- -----------------------------------------------------
-- (0.2) - Create Visitantes
-- ----------------------------------------------------- 

    CREATE ROLE LoginVisitante;

    GRANT CONNECT ON DATABASE bancosdedados2020 TO LoginVisitante;
    GRANT USAGE   ON SCHEMA   venda_ingressos   TO LoginVisitante;
    GRANT SELECT ON Evento, Apresentacao TO LoginVisitante;

    CREATE USER Default_Guest WITH
    IN ROLE LoginVisitante
    PASSWORD '123';

-- -----------------------------------------------------
-- (0.3) - Create Administradores
-- ----------------------------------------------------- 

    CREATE ROLE Administrator WITH
    SUPERUSER
    CREATEROLE
    INHERIT
    ADMIN LoginUsuario, LoginVisitante;

    GRANT ALL PRIVILEGES ON DATABASE bancosdedados2020 TO Administrator;
    GRANT CONNECT ON DATABASE        bancosdedados2020 TO Administrator;
    GRANT ALL PRIVILEGES ON SCHEMA   venda_ingressos   TO Administrator;
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA venda_ingressos TO Administrator;

    CREATE USER adm WITH 
    IN ROLE Administrator
    PASSWORD '123';


-- -----------------------------------------------------
-- (1.0) - Create Tables
-- -----------------------------------------------------
-- -----------------------------------------------------
-- (1.1) - Table Usuario
-- -----------------------------------------------------
    CREATE TABLE IF NOT EXISTS Usuario(
        idCPF               CHAR   (11) NOT NULL,
        Nome                VARCHAR(20) NOT NULL UNIQUE,
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
    ON UPDATE      RESTRICT;
    
    ALTER TABLE ONLY Apresentacao
    ADD CONSTRAINT fkCodigoEvento FOREIGN KEY (fkCodigoEvento) 
    REFERENCES     Evento(idCodigoEvento)
    ON UPDATE      CASCADE
    ON DELETE      CASCADE;

    ALTER TABLE ONLY Ingresso
    ADD CONSTRAINT fkCodigoApresentacao FOREIGN KEY (fkCodigoApresentacao) 
    REFERENCES     Apresentacao(idCodigoApresentacao)
    ON UPDATE      CASCADE
    ON DELETE      RESTRICT;

    ALTER TABLE ONLY Ingresso
    ADD CONSTRAINT fkCPF FOREIGN KEY (fkCPF) 
    REFERENCES     Usuario(idCPF)
    ON UPDATE      RESTRICT;



-- -----------------------------------------------------
-- (4.0) - Create policy
-- ----------------------------------------------------- 

    ALTER TABLE Usuario       ENABLE ROW LEVEL SECURITY;
    ALTER TABLE CartaoCredito ENABLE ROW LEVEL SECURITY;
    ALTER TABLE Evento        ENABLE ROW LEVEL SECURITY;
    ALTER TABLE Apresentacao  ENABLE ROW LEVEL SECURITY;
    ALTER TABLE Ingresso      ENABLE ROW LEVEL SECURITY;

-- -----------------------------------------------------
-- (4.1) - Create policy Usuario
-- ----------------------------------------------------- 

    CREATE POLICY PSelectUsuario ON Usuario
    FOR SELECT
    USING (current_user = Nome);

-- -----------------------------------------------------
-- (4.2) - Create policy CartaoCredito
-- ----------------------------------------------------- 

    CREATE POLICY PSelectCartaoCredito ON CartaoCredito
    FOR SELECT 
    USING (TRUE);

    CREATE POLICY PUpdateCartaoCredito ON CartaoCredito
    FOR UPDATE 
    USING (TRUE)

-- -----------------------------------------------------
-- (4.3) - Create policy Evento
-- ----------------------------------------------------- 
-- -----------------------------------------------------
-- (4.4) - Create policy Apresentacao
-- ----------------------------------------------------- 
-- -----------------------------------------------------
-- (4.5) - Create policy Ingresso
-- ----------------------------------------------------- 
-- -----------------------------------------------------
-- (5.0) - Views
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

    CREATE OR REPLACE VIEW NIngressosVendidosEvento
    AS (SELECT SUM(i.Quantidade), fkCodigoEvento
    FROM Apresentacao a 
    JOIN Ingresso i ON a.idCodigoApresentacao = i.fkCodigoApresentacao
    GROUP BY a.fkCodigoEvento);

    CREATE OR REPLACE VIEW NIngressosVendidosApresentacao
    AS SELECT SUM(i.Quantidade) AS Total, fkCodigoApresentacao
    FROM Ingresso i
    GROUP BY i.fkCodigoApresentacao;

-- -----------------------------------------------------
-- (6.0) - Functions
-- -----------------------------------------------------
-- -----------------------------------------------------
-- (6.1) - Usuario Functions
-- -----------------------------------------------------
    CREATE OR REPLACE FUNCTION ValidarCPF(CPF CHAR(11)) RETURNS BOOLEAN
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

    CREATE OR REPLACE FUNCTION CriarLoginOnDB() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
    BEGIN
        EXECUTE FORMAT ('CREATE USER ' || NEW.Nome || ' WITH PASSWORD ''' || NEW.Senha || ''' IN GROUP LoginUsuario') USING NEW.Senha; 
        RETURN NEW;
    END $$;

    CREATE OR REPLACE FUNCTION DeletarLoginOnDB() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
    BEGIN
        EXECUTE FORMAT ('DROP ROLE ' || OLD.Nome);
        RETURN NULL;
    END $$;

-- -----------------------------------------------------
-- (6.2) - CartaoCredito Functions
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
-- (6.3) - Evento Functions
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

    CREATE OR REPLACE FUNCTION VerificarVendaIngressoEvento () RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
    BEGIN
    IF (SELECT SUM FROM NIngressosVendidosEvento AS ni WHERE ni.fkCodigoEvento = NEW.idCodigoEvento IS NOT NULL) THEN
        RAISE EXCEPTION '\n\nEvento nao pode ser deletado por haver ingressos vendidos\n\n';
    ELSE
        RETURN NEW;        
    END IF;
    END $$;

-- -----------------------------------------------------
-- (6.4) - Apresentacao Functions
-- -----------------------------------------------------

    CREATE OR REPLACE FUNCTION VerificaResponsavelEvento () RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
    BEGIN 
        IF ((SELECT NOME FROM Usuario 
        JOIN Evento ON idCPF = fkCPF AND idCodigoEvento = 1
        WHERE Nome = current_user) IS NULL) THEN
            RAISE EXCEPTION 'Eh permitido criar apresentacoes para eventos que estiver em seu cpf apenas';
            RETURN NULL;
        ELSE 
            RETURN NEW;
        END IF;
    END $$;

-- -----------------------------------------------------
-- (6.5) - Ingresso Functions
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
        RAISE EXCEPTION '\n\nQuantidade requerida nao disponivel\n\n';
    END IF;

    RETURN NEW;
    END $disp$;

-- -----------------------------------------------------
-- (6.6) - String Functions
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
-- (7.0) - Restrictions
-- -----------------------------------------------------
-- -----------------------------------------------------
-- (7.1) - Usuario restrictions
-- -----------------------------------------------------
    ALTER TABLE Usuario 
    ADD CONSTRAINT cValidarCPF 
    CHECK (ValidarCPF(idCPF));

    ALTER TABLE Usuario 
    ADD CONSTRAINT cValidarSenha 
    CHECK (ValidarSenha(Senha));

    CREATE TRIGGER CriarLoginUsuario
    AFTER INSERT ON Usuario
    FOR EACH ROW 
    EXECUTE PROCEDURE CriarLoginOnDB();

    CREATE TRIGGER DeletarLoginUsuario
    AFTER DELETE ON Usuario
    FOR EACH ROW 
    EXECUTE PROCEDURE DeletarLoginOnDB();

-- -----------------------------------------------------
-- (7.2) - CartaoCredito restrictions
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
-- (7.3) - Evento restrictions
-- -----------------------------------------------------
    ALTER TABLE    Evento
    ADD CONSTRAINT cValidaridCodigoEvento 
    CHECK          (idCodigoEvento >= 0 AND idCodigoEvento <= 999);

    ALTER TABLE    Evento
    ADD CONSTRAINT cValidarNomeEvento 
    CHECK          (ValidarNomeEvento(NomeEvento));

    ALTER TABLE    Evento
    ADD CONSTRAINT cValidarCidade 
    CHECK          (ValidarCidade(Cidade));

    ALTER TABLE    Evento
    ADD CONSTRAINT cValidarEstado
    CHECK          (ValidarEstado(Estado));

    ALTER TABLE    Evento
    ADD CONSTRAINT cValidarFaixaEtaria 
    CHECK          (ValidarFaixaEtaria(FaixaEtaria));

    ALTER TABLE    Evento
    ADD CONSTRAINT cValidarClasseEvento 
    CHECK          (ClasseEvento >= 1 AND ClasseEvento <= 4);

    CREATE TRIGGER cVerificarVendaIngressoEvento
    BEFORE DELETE ON Evento
    FOR EACH ROw
    EXECUTE PROCEDURE VerificarVendaIngressoEvento ();

-- -----------------------------------------------------
-- (7.4) - Apresentacao restrictions
-- -----------------------------------------------------
    ALTER TABLE    Apresentacao
    ADD CONSTRAINT cValidaridCodigoApresentacao 
    CHECK          (idCodigoApresentacao > -1 AND idCodigoApresentacao < 10000);

    ALTER TABLE    Apresentacao
    ADD CONSTRAINT cValidarPreco 
    CHECK          (Preco >= 0 AND Preco <= 1000);

    ALTER TABLE    Apresentacao
    ADD CONSTRAINT cValidarNumeroSala 
    CHECK          (NumeroSala >= 0 AND NumeroSala <= 10);

    ALTER TABLE    Apresentacao
    ADD CONSTRAINT cValidarDisponibilidade 
    CHECK          (Disponibilidade >= 0 AND Disponibilidade <= 250);

    CREATE TRIGGER cVerificaResponsavelEvento  
    BEFORE INSERT ON Apresentacao
    FOR EACH ROW
    EXECUTE PROCEDURE VerificaResponsavelEvento();

-- -----------------------------------------------------
-- (7.5) - Ingresso restrictions
-- -----------------------------------------------------
    ALTER TABLE      Ingresso
    ADD CONSTRAINT cValidaridCodigoIngresso 
    CHECK          (idCodigoIngresso >= 0 AND idCodigoIngresso <= 99999);

    CREATE TRIGGER   tValidarQuantidade
    BEFORE INSERT ON Ingresso
    FOR EACH ROW
    EXECUTE PROCEDURE VerificarDisponibilidade();



-- -----------------------------------------------------
-- (8.0) - Procedures
-- -----------------------------------------------------
-- -----------------------------------------------------
-- (8.1) - Procedures Create        
-- -----------------------------------------------------
    CREATE OR REPLACE PROCEDURE CriarUsuario (CPF CHAR(11), Nome VARCHAR(20), Senha CHAR(6), DataNascimento DATE)
    LANGUAGE plpgsql
    AS $insertusuario$
    BEGIN
    INSERT INTO Usuario VALUES (CPF, Nome, Senha, DataNascimento); 
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

    CREATE OR REPLACE PROCEDURE CriarApresentacao (fkCodigoEvento INTEGER, Preco FLOAT, DataHorario TIMESTAMP, NumeroSala SMALLINT, Disponibilidade SMALLINT)
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
-- (8.2) - Procedures Read
-- -----------------------------------------------------
-- -----------------------------------------------------
-- (8.3) - Procedures Update
-- -----------------------------------------------------
    CREATE OR REPLACE PROCEDURE UpdateUsuario (uOldCPF CHAR(11), uNewCPF CHAR(11), uNome VARCHAR(20), uSenha CHAR(6), uDatadeNascimento DATE)
    LANGUAGE plpgsql
    AS $updateusuario$
    BEGIN
    UPDATE Usuario SET idCPF = uNewCPF, Nome = uNome, Senha = uSenha, DatadeNascimento = uDatadeNascimento WHERE idCPF = uOldCPF; 
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
-- (8.4) - Procedures Delete
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
-- (9.0) - Testes e debug
-- -----------------------------------------------------
-- ----------------------------------------------------- 
-- (9.1) - Restrict do DELETE de um CPF com referencia
-- -----------------------------------------------------
    -- Verifica se o cpf com referencia não pode ser atualizado 
    -- e nem deletado
    CALL CriarUsuario       ('05370637148', 'alexandre', '1234aA', '19/01/20');
    CALL CriarUsuario       ('63892733040', 'caio', '1234aA', '19/01/20');
    CALL CriarCartaoCredito ('5467097237169470', '0120', '123', '05370637148');
    UPDATE Usuario SET idCPF = '57219981058' WHERE idCPF = '05370637148';
    DELETE FROM Usuario;
    
-- ----------------------------------------------------- 
-- (9.2) - Cascade do Código de Evento em Apresentacao
-- -----------------------------------------------------
    -- Verifica se houve atualizacao do codigo evento 
    CALL CriarEvento ('05370637148', 'Rock in Rio', 'Formosa', 'L', 'GO', 1::SMALLINT);
    CALL CriarApresentacao (1, 123.0, '19/01/20 19:00:00', 2::SMALLINT, 150::SMALLINT);
    UPDATE Evento SET idCodigoEvento = 2 WHERE idCodigoEvento = 1;
    SELECT * FROM Apresentacao;

-- ----------------------------------------------------- 
-- (9.3) - Teste dos restrictions Usuario
-- -----------------------------------------------------
    -- Teste do validar CPF
    DELETE FROM Usuario CASCADE;
    CALL CriarUsuario ('05370637142', 'alexandre', '1234aA', '19/01/20'); -- CPF Invalido

    -- Teste do validar senha
    CALL CriarUsuario ('05370637148', 'Alexandre', '12345A', '19/01/20'); -- CPF Invalido
    
-- ----------------------------------------------------- 
-- (9.4) - Teste dos restrictions CartaoCredito
-- -----------------------------------------------------
    CALL CriarUsuario ('05370637148', 'Alexandre', '1234aA', '19/01/20'); -- CPF Valido

    -- Verifica a vaidade do numero de cartao de credito
    CALL CriarCartaoCredito ('5467097237169471', '0299', 999::SMALLINT, '05370637148');

    -- Verifica a validade da data de validade
    CALL CriarCartaoCredito ('5467097237169470', '0099', 999::SMALLINT, '05370637148');    SELECT * FROM CartaoCredito;

    -- Cartao valido
    CALL CriarCartaoCredito ('5467097237169470', '0299', 999::SMALLINT, '05370637148');    SELECT * FROM CartaoCredito;
    
-- ----------------------------------------------------- 
-- (9.5) - Teste dos restrictions Evento
-- -----------------------------------------------------
    -- Verifica formato do nome do evento
    CALL CriarEvento('05370637148', 'Rock in  Rio', 'Formosa', 'L', 'GO', 1::SMALLINT);
    CALL CriarEvento('05370637148', 'Rock in @Rio', 'Formosa', 'L', 'GO', 1::SMALLINT);

    -- Verifica a validade da cidade
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa.2', 'L', 'GO', 1::SMALLINT);
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa@' , 'L', 'GO', 1::SMALLINT);

    -- Verifica a validade da estado
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa', 'L', 'Go', 1::SMALLINT);
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa', 'L', 'GA', 1::SMALLINT);

    -- Verifica a validade da FaixaEtaria
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa', ' A', 'GO', 1::SMALLINT);
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa', '11', 'GO', 1::SMALLINT);

    -- Verifica se quando um evento é vendido, não pode ser deletado
    CALL CriarEvento('05370637148', 'Rock in Rio', 'Formosa', '12', 'GO', 1::SMALLINT);
    CALL CriarApresentacao (1, 123.0, '19/01/20 19:00:00', 2::SMALLINT, 150::SMALLINT);
    CALL CriarIngresso (1::SMALLINT, '05370637148', 150::SMALLINT);
    DELETE FROM EVENTO;

-- ----------------------------------------------------- 
-- (9.6) - Teste dos restrictions Ingresso
-- -----------------------------------------------------
    -- Verifica se a quantidade de ingressos comprados tem disponivel
    -- e se disponivel, alterou na tabela apresentacao
    SELECT * FROM Apresentacao;
    CALL CriarIngresso (1::SMALLINT, '05370637148', 151::SMALLINT);
    CALL CriarIngresso (1::SMALLINT, '05370637148', 150::SMALLINT);
    SELECT * FROM Apresentacao;


