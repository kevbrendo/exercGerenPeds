create database gerenc_pedidos1;

use gerenc_pedidos1;

-- Criação da tabela "Clientes"
CREATE TABLE Clientes (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    NomeCliente VARCHAR(255),
    Email VARCHAR(255),
    TotalPedidos DECIMAL(10, 2)
);

-- Criação da tabela "Pedidos"
CREATE TABLE Pedidos (
    PedidoID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT,
    DataPedido DATE,
    ValorPedido DECIMAL(10, 2),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

-- Etapa 2: Criação de Stored Procedure

DELIMITER //
CREATE PROCEDURE InserirPedido(
    IN Cliente_ID INT,
    IN Data_Pedido DATE,
    IN Valor_Pedido DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Pedidos (ClienteID, DataPedido, ValorPedido)
    VALUES (Cliente_ID, Data_Pedido, Valor_Pedido);
END //
DELIMITER ;

-- Etapa 3: Trigger

DELIMITER //
CREATE TRIGGER CalculaTotalPedidos
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    UPDATE Clientes
    SET TotalPedidos = (
        SELECT SUM(ValorPedido)
        FROM Pedidos
        WHERE ClienteID = NEW.ClienteID
    )
    WHERE ClienteID = NEW.ClienteID;
END //
DELIMITER ;

-- Etapa 4: View

CREATE VIEW PedidosClientes AS
SELECT
    c.ClienteID,
    c.NomeCliente,
    p.PedidoID,
    p.DataPedido,
    p.ValorPedido
FROM Clientes c
JOIN Pedidos p ON c.ClienteID = p.ClienteID;

-- Etapa 5: Consulta com JOIN
SELECT
    pc.ClienteID,
    pc.NomeCliente,
    pc.PedidoID,
    pc.DataPedido,
    pc.ValorPedido,
    c.TotalPedidos
FROM PedidosClientes pc
JOIN Clientes c ON pc.ClienteID = c.ClienteID;

INSERT INTO Clientes (NomeCliente, Email, TotalPedidos) VALUES
('Cliente 1', 'cliente1@example.com', 0),
('Cliente 2', 'cliente2@example.com', 0),
-- Continue adicionando mais clientes até ter pelo menos 20
('Cliente 20', 'cliente20@example.com', 0);

-- Inserção de pedidos para o Cliente 1
CALL InserirPedido(1, '2023-10-30', 100.00);
CALL InserirPedido(1, '2023-10-31', 150.00);

-- Inserção de pedidos para o Cliente 2
CALL InserirPedido(2, '2023-10-30', 75.00);
CALL InserirPedido(2, '2023-10-31', 120.00);


