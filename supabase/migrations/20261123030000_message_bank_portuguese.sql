-- Banque de messages en portugais (ADR-038) : 40 messages en portugais du Brésil, compris au
-- Portugal, mêmes catégories et même charte que les autres langues (ADR-034).

insert into public.message_bank (language, category, sort_order, body) values
  -- Primeira mensagem: uma pergunta pessoal em vez de um simples "oi".
  ('pt', 'opener', 1, 'Tenho uma pergunta importante: noite de filmes ou passeio no pôr do sol?'),
  ('pt', 'opener', 2, 'Seu perfil me fez sorrir, e isso não acontece com frequência. O que fez você sorrir hoje?'),
  ('pt', 'opener', 3, 'Vi que você adora viajar. Para qual lugar você voltaria amanhã sem pensar duas vezes?'),
  ('pt', 'opener', 4, 'Oi! Parece que a gente tem gostos parecidos. Qual foi sua melhor descoberta musical das últimas semanas?'),
  ('pt', 'opener', 5, 'Primeiras mensagens não são o meu forte, então vou direto ao ponto: eu adoraria conhecer você.'),
  ('pt', 'opener', 6, 'Pergunta séria: abacaxi na pizza, crime ou genialidade? Sua resposta é muito importante 😄'),
  ('pt', 'opener', 7, 'Sua foto da trilha me deu vontade de sair em uma aventura. Onde foi?'),
  ('pt', 'opener', 8, 'Se você pudesse ter um superpoder só neste fim de semana, qual seria?'),
  -- Retomar: voltar a escrever sem cobrança nem pressão.
  ('pt', 'follow_up', 1, 'Oi! Lembrei da nossa conversa do outro dia. Como foi sua semana?'),
  ('pt', 'follow_up', 2, 'Acabei de ver uma coisa que me fez pensar em você 😄 Como você está?'),
  ('pt', 'follow_up', 3, 'Só passando para dar um oi, sem pressão. Espero que esteja tudo bem por aí.'),
  ('pt', 'follow_up', 4, 'E aquela série que você me indicou? Quero saber se vale a pena começar!'),
  ('pt', 'follow_up', 5, 'Paramos no meio de um debate e eu ainda não tenho uma opinião formada. E você?'),
  ('pt', 'follow_up', 6, 'Parece que sua semana foi corrida. Força, e espero falar com você em breve!'),
  ('pt', 'follow_up', 7, 'Retomando nossa conversa com uma pergunta fácil: qual foi o melhor momento da sua semana?'),
  ('pt', 'follow_up', 8, 'Oi! Não queria deixar nossa conversa morrer, eu estava gostando muito de falar com você.'),
  -- Encontro: propor de forma simples, deixando a porta aberta.
  ('pt', 'date', 1, 'Gosto muito das nossas conversas. Que tal continuar tomando alguma coisa esta semana?'),
  ('pt', 'date', 2, 'Conheço um café pequeno com o melhor chocolate quente da cidade. Topa conferir comigo?'),
  ('pt', 'date', 3, 'Faz dias que a gente fala de passeios… e se a gente fizesse um neste fim de semana?'),
  ('pt', 'date', 4, 'Eu adoraria ver você pessoalmente. Você está livre na quinta ou na sexta à noite?'),
  ('pt', 'date', 5, 'Proposta simples: um drinque, uma hora, e a gente vê se se dá tão bem quanto aqui. Topa?'),
  ('pt', 'date', 6, 'Tem uma exposição que parece incrível agora. Quer ir comigo?'),
  ('pt', 'date', 7, 'Tenho curiosidade de saber se você tem o mesmo humor pessoalmente e por mensagem. Um café?'),
  ('pt', 'date', 8, 'Sem pressão se não for um bom momento, mas eu adoraria que a gente se conhecesse pessoalmente.'),
  -- Desculpas: sinceras, sem se justificar demais.
  ('pt', 'apology', 1, 'Desculpa pelo que aconteceu mais cedo. Não foi legal da minha parte e entendo que isso tenha te magoado.'),
  ('pt', 'apology', 2, 'Te devo um pedido de desculpas: demorei muito para responder, e essa não é a imagem que eu queria passar.'),
  ('pt', 'apology', 3, 'Pensei no que você me disse e você tem razão. Desculpa.'),
  ('pt', 'apology', 4, 'Desculpa por cancelar em cima da hora. Eu adoraria compensar, se você topar.'),
  ('pt', 'apology', 5, 'Minha mensagem foi desajeitada, peço desculpas. Não era isso que eu queria dizer.'),
  ('pt', 'apology', 6, 'Não vou inventar desculpas: eu errei e me arrependo sinceramente.'),
  ('pt', 'apology', 7, 'Entendo se você precisar de um tempo. Só queria dizer que sinto muito, de verdade.'),
  ('pt', 'apology', 8, 'Eu não deveria ter reagido daquele jeito. Agradeço por me dizer como você se sentiu.'),
  -- Término gentil: claro, respeitoso, sem falsas esperanças.
  ('pt', 'soft_breakup', 1, 'Passei bons momentos com você, mas não sinto o que seria preciso para ir além. Prefiro abrir o jogo com você.'),
  ('pt', 'soft_breakup', 2, 'Digo isso com sinceridade: não acho que a gente combine. Desejo de verdade o melhor para você.'),
  ('pt', 'soft_breakup', 3, 'Agradeço pelas nossas conversas. Da minha parte, prefiro não continuar, e queria dizer isso diretamente.'),
  ('pt', 'soft_breakup', 4, 'Você é uma pessoa incrível, mas agora não estou num bom momento para um relacionamento.'),
  ('pt', 'soft_breakup', 5, 'Prefiro falar do que sumir: não quero que a gente se veja de novo. Se cuida!'),
  ('pt', 'soft_breakup', 6, 'Pensei muito e acho melhor pararmos por aqui. Agradeço por tudo.'),
  ('pt', 'soft_breakup', 7, 'Não é fácil escrever isso, mas não vejo futuro para nós. Não queria deixar você na dúvida.'),
  ('pt', 'soft_breakup', 8, 'Guardo uma boa lembrança dos nossos momentos, mas prefiro terminar aqui. Espero que você encontre o que procura.');
