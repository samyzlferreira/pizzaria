USE Pizzaria;
-- Desafio 02
DROP TRIGGER IF EXISTS atualizaValorPedido;
DELIMITER $$

CREATE TRIGGER atualizaValorPedido
AFTER INSERT ON Itens_Pedido
FOR EACH ROW
BEGIN
    UPDATE Pedidos
    SET valor = (
        SELECT SUM(quantidade * valor)
        FROM Itens_Pedido
        WHERE pedido_id = NEW.pedido_id
    )
    WHERE pedido_id = NEW.pedido_id;
END $$
DELIMITER ;
-- 1: Claudiane Mendes Trigueiro Silva
INSERT INTO Pedidos (cliente_id, data, hora, valor)
VALUES (14, CURDATE(), CURTIME(), NULL);

SET @pedido_id = LAST_INSERT_ID();
SET @pedido_claudiane = @pedido_id;

INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade, valor)
VALUES
(@pedido_id, 3, 2, (SELECT valor FROM Pizzas WHERE pizza_id = 3)),
(@pedido_id, 16, 1, (SELECT valor FROM Pizzas WHERE pizza_id = 16));

-- 2: Diogo Matos da Silva
INSERT INTO Pedidos (cliente_id, data, hora, valor)
VALUES (24, CURDATE(), CURTIME(), NULL);

SET @pedido_id = LAST_INSERT_ID();
SET @pedido_diogo = @pedido_id;

INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade, valor)
VALUES
(@pedido_id, 39, 2, (SELECT valor FROM Pizzas WHERE pizza_id = 39)),
(@pedido_id, 20, 1, (SELECT valor FROM Pizzas WHERE pizza_id = 20));

-- 3: Eder Almeida Batista de Oliveira
INSERT INTO Pedidos (cliente_id, data, hora, valor)
VALUES (27, CURDATE(), CURTIME(), NULL);

SET @pedido_id = LAST_INSERT_ID();
SET @pedido_eder = @pedido_id;

INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade, valor)
VALUES
(@pedido_id, 11, 1, (SELECT valor FROM Pizzas WHERE pizza_id = 11)),
(@pedido_id, 22, 2, (SELECT valor FROM Pizzas WHERE pizza_id = 22));

SELECT
    p.pedido_id,
    c.nome AS cliente,
    p.valor AS valor_pedido
FROM Pedidos p
JOIN Clientes c ON c.cliente_id = p.cliente_id
WHERE p.pedido_id IN (@pedido_claudiane, @pedido_diogo, @pedido_eder)
ORDER BY p.pedido_id;

SELECT
    ip.pedido_id,
    pi.nome AS pizza,
    ip.quantidade,
    ip.valor AS valor_unitario,
    (ip.quantidade * ip.valor) AS subtotal
FROM Itens_Pedido ip
JOIN Pizzas pi ON pi.pizza_id = ip.pizza_id
WHERE ip.pedido_id IN (@pedido_claudiane, @pedido_diogo, @pedido_eder)
ORDER BY ip.pedido_id, pi.nome;