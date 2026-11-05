CREATE TABLE Cliente(
	id_cliente INT NOT NULL AUTO_INCREMENT,
  	nome VARCHAR(50),
    PRIMARY KEY(id_cliente)
  );
  
CREATE TABLE Produto(
	id_produto INT NOT NULL AUTO_INCREMENT,
  	nome VARCHAR(50),
    preco DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY(id_produto)
  );
  
  CREATE TABLE Pedido(
	id_pedido INT Not NULL AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    data_pedido DATE,
    PRIMARY KEY(id_pedido),
    
    FOREIGN KEY(id_cliente) REFERENCES Cliente(id_cliente)
  );
  
  CREATE TABLE Item_Pedido(
	id_item INT Not NULL AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT,
    PRIMARY KEY(id_item),
    
    FOREIGN KEY(id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY(id_produto) REFERENCES Produto(id_produto)
  );
  
  CREATE TABLE Auditoria_Pedido(
	id_auditoria INT Not NULL AUTO_INCREMENT,
    id_pedido INT NOT NULL,
	acao VARCHAR(50),
    data_modificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON           UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(id_auditoria),
  
    FOREIGN KEY(id_pedido) REFERENCES Pedido(id_pedido)
  );
  
  
  DELIMITER //
  
  CREATE PROCEDURE InserirPedido (
    IN p_id_cliente INT,
    IN p_data_pedido DATE,
    IN p_id_produto1 INT,
    IN p_qtd1 INT,
    IN p_id_produto2 INT,
    IN p_qtd2 INT
)
BEGIN
DECLARE novo_pedido_id INT;



 INSERT INTO PEDIDO (id_cliente, data_pedido)
    VALUES (p_id_cliente, p_data_pedido);

    SET novo_pedido_id = LAST_INSERT_ID();
    
    
 INSERT INTO ITEM_PEDIDO (id_pedido, id_produto, quantidade)
    VALUES (novo_pedido_id, p_id_produto1, p_qtd1),
           (novo_pedido_id, p_id_produto2, p_qtd2);
END //

DELIMITER ;


DELIMITER //

CREATE FUNCTION CalcularTotalPedido(pedido_id INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(p.preco * ip.quantidade)
    INTO total
    FROM ITEM_PEDIDO ip
    JOIN PRODUTO p ON ip.id_produto = p.id_produto
    WHERE ip.id_pedido = pedido_id;

    RETURN IFNULL(total, 0);
END //

DELIMITER ;





DELIMITER //

CREATE TRIGGER trg_auditoria_pedido
AFTER UPDATE ON PEDIDO
FOR EACH ROW
BEGIN
    INSERT INTO AUDITORIA_PEDIDO (id_pedido, acao)
    VALUES (NEW.id_pedido, 'UPDATE');
END //

DELIMITER ;
