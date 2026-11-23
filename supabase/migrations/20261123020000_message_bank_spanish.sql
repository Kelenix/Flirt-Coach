-- Banque de messages en espagnol (ADR-036) : 40 messages en espagnol neutre (Espagne et
-- Amérique latine), mêmes catégories et même charte que les autres langues (ADR-034).

insert into public.message_bank (language, category, sort_order, body) values
  -- Primer mensaje: una pregunta personal en lugar de un simple «hola».
  ('es', 'opener', 1, 'Tengo que hacerte una pregunta importante: ¿noche de películas o paseo al atardecer?'),
  ('es', 'opener', 2, 'Tu perfil me hizo sonreír, y eso no pasa muy seguido. ¿Qué te hizo sonreír a ti hoy?'),
  ('es', 'opener', 3, 'Vi que te encanta viajar. ¿A qué lugar volverías mañana sin pensarlo dos veces?'),
  ('es', 'opener', 4, '¡Hola! Parece que tenemos gustos parecidos. ¿Cuál es tu mejor descubrimiento musical de las últimas semanas?'),
  ('es', 'opener', 5, 'Los primeros mensajes no son lo mío, así que lo haré simple: me encantaría conocerte.'),
  ('es', 'opener', 6, 'Pregunta seria: piña en la pizza, ¿crimen o genialidad? Tu respuesta es muy importante 😄'),
  ('es', 'opener', 7, 'Tu foto de senderismo me dio ganas de salir de aventura. ¿Dónde fue?'),
  ('es', 'opener', 8, 'Si pudieras tener un superpoder solo por este fin de semana, ¿cuál sería?'),
  -- Retomar: volver a escribir sin reproches ni presión.
  ('es', 'follow_up', 1, '¡Hola! Me acordé de nuestra conversación del otro día. ¿Cómo estuvo tu semana?'),
  ('es', 'follow_up', 2, 'Acabo de ver algo que me hizo pensar en ti 😄 ¿Cómo estás?'),
  ('es', 'follow_up', 3, 'Solo paso a saludar, sin presión. Espero que todo vaya bien por tu lado.'),
  ('es', 'follow_up', 4, '¿Y qué tal la serie de la que me hablaste? ¡Quiero saber si vale la pena empezarla!'),
  ('es', 'follow_up', 5, 'Nos quedamos a mitad de un debate y todavía no tengo una opinión clara. ¿Y tú?'),
  ('es', 'follow_up', 6, 'Parece que tu semana ha estado llena. ¡Ánimo, y espero leerte pronto!'),
  ('es', 'follow_up', 7, 'Retomo nuestra conversación con una pregunta fácil: ¿cuál fue el mejor momento de tu semana?'),
  ('es', 'follow_up', 8, '¡Hola! No quería que nuestra conversación se apagara, me gustaba mucho hablar contigo.'),
  -- Cita: proponer de forma sencilla, dejando la puerta abierta.
  ('es', 'date', 1, 'Me gustan mucho nuestras conversaciones. ¿Te gustaría seguirlas con algo de tomar esta semana?'),
  ('es', 'date', 2, 'Conozco un café pequeño con el mejor chocolate caliente de la ciudad. ¿Te animas a comprobarlo conmigo?'),
  ('es', 'date', 3, 'Llevamos días hablando de paseos… ¿y si damos uno este fin de semana?'),
  ('es', 'date', 4, 'Me gustaría verte en persona. ¿Estás libre el jueves o el viernes por la noche?'),
  ('es', 'date', 5, 'Propuesta sencilla: algo de tomar, una hora, y vemos si nos llevamos tan bien como aquí. ¿Te animas?'),
  ('es', 'date', 6, 'Hay una exposición que se ve genial ahora mismo. ¿Te gustaría ir conmigo?'),
  ('es', 'date', 7, 'Tengo curiosidad por saber si tienes el mismo humor en persona que por mensajes. ¿Un café?'),
  ('es', 'date', 8, 'Sin presión si no es buen momento, pero me encantaría que nos conociéramos en persona.'),
  -- Disculpas: sinceras, sin justificarse de más.
  ('es', 'apology', 1, 'Perdón por lo de hace rato. No estuvo bien de mi parte y entiendo que te haya dolido.'),
  ('es', 'apology', 2, 'Te debo una disculpa: tardé mucho en responder y esa no es la imagen que quería dar.'),
  ('es', 'apology', 3, 'Pensé en lo que me dijiste y tienes razón. Lo siento.'),
  ('es', 'apology', 4, 'Perdón por cancelar a último momento. Me gustaría mucho compensarte, si te parece bien.'),
  ('es', 'apology', 5, 'Mi mensaje fue torpe, te pido disculpas. No es lo que quería decir.'),
  ('es', 'apology', 6, 'No busco excusas: me equivoqué y lo lamento de verdad.'),
  ('es', 'apology', 7, 'Entiendo si necesitas tiempo. Solo quería decirte que lo siento de verdad.'),
  ('es', 'apology', 8, 'No debí reaccionar así. Gracias por decirme cómo te sentiste.'),
  -- Ruptura suave: clara, respetuosa, sin falsas esperanzas.
  ('es', 'soft_breakup', 1, 'He pasado buenos momentos contigo, pero no siento lo necesario para ir más allá. Prefiero hablarte con sinceridad.'),
  ('es', 'soft_breakup', 2, 'Te lo digo con sinceridad: no creo que seamos el uno para el otro. De verdad te deseo lo mejor.'),
  ('es', 'soft_breakup', 3, 'Gracias por nuestras conversaciones. Por mi parte, prefiero no seguir, y quería decírtelo directamente.'),
  ('es', 'soft_breakup', 4, 'Eres una persona genial, pero ahora mismo no estoy en un buen momento para una relación.'),
  ('es', 'soft_breakup', 5, 'Prefiero decírtelo antes que desaparecer: no quiero que nos volvamos a ver. Cuídate mucho.'),
  ('es', 'soft_breakup', 6, 'Lo pensé mucho y creo que es mejor dejarlo aquí. Gracias por todo.'),
  ('es', 'soft_breakup', 7, 'No es fácil escribir esto, pero no veo futuro en lo nuestro. No quería dejarte con la duda.'),
  ('es', 'soft_breakup', 8, 'Me quedo con un buen recuerdo de nuestros momentos, pero prefiero terminar aquí. Espero que encuentres lo que buscas.');
