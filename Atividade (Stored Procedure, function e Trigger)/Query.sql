INSERT INTO Cliente (nome) VALUES 
('Giovanna Andrade'),
('Kira Beriba'),
('Giulia Stypurski');

INSERT INTO Produto (nome, preco) VALUES 
('Notebook', 3500.00),
('Fone de ouvido', 80.00),
('Teclado Mecânico', 250.00),
('Monitor', 1200.00);

CALL InserirPedido(1, CURDATE(), 2, 68, 3, 5);
CALL InserirPedido(2, DATE_SUB(CURDATE(), INTERVAL 12 DAY), 1, 1, 4, 15);
CALL InserirPedido(3, DATE_SUB(CURDATE(), INTERVAL 44 DAY), 2, 3, 3, 2);

UPDATE Pedido SET data_pedido = CURDATE() WHERE id_pedido = 1;

SELECT 
    p.id_pedido,
    c.nome AS nome_cliente,
    SUM(pr.preco * ip.quantidade) AS total_gasto,
    SUM(ip.quantidade) AS quantidade_total_itens
	FROM Pedido p
	JOIN Cliente c ON p.id_cliente = c.id_cliente
	JOIN Item_Pedido ip ON p.id_pedido = ip.id_pedido
	JOIN Produto pr ON ip.id_produto = pr.id_produto
	GROUP BY p.id_pedido, c.nome
	ORDER BY total_gasto DESC;


SELECT 
    p.id_pedido,
    p.data_pedido,
    c.nome AS nome_cliente,
    MAX(a.data_modificacao) AS data_ultima_modificacao
	FROM Pedido p
	JOIN Cliente c ON p.id_cliente = c.id_cliente
	LEFT JOIN Auditoria_Pedido a ON p.id_pedido = a.id_pedido
	WHERE p.data_pedido >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
	GROUP BY p.id_pedido, p.data_pedido, c.nome;

SELECT 
    pr.nome AS nome_produto,
    SUM(ip.quantidade) AS quantidade_total_vendida,
    IF(SUM(ip.quantidade) > 50, 'Mais que 50 unidades',
       IF(SUM(ip.quantidade) >= 10, 'Entre 10 e 50 unidades', 			'Menos que 10 unidades')) AS categoria_ficticia
	FROM Produto pr
	JOIN Item_Pedido ip ON pr.id_produto = ip.id_produto
	GROUP BY pr.id_produto, pr.nome;
