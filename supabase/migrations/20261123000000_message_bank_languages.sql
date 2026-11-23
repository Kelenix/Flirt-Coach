-- Banque de messages multilingue (ADR-034) : chaque message a sa langue (code ISO 639),
-- l'app lit celle de son interface. Les 40 messages existants sont en français ; les 40
-- messages anglais sont ajoutés ici. Ajouter une langue = une migration d'insertion.

alter table public.message_bank
  add column language text not null default 'fr' check (language ~ '^[a-z]{2,3}$');

-- La langue est désormais obligatoire pour toute nouvelle ligne.
alter table public.message_bank alter column language drop default;

alter table public.message_bank drop constraint message_bank_category_sort_order_key;
alter table public.message_bank
  add constraint message_bank_language_category_sort_order_key
  unique (language, category, sort_order);

insert into public.message_bank (language, category, sort_order, body) values
  -- Openers: a personal hook rather than a plain "hi".
  ('en', 'opener', 1, 'I have an important question for you: movie night or a sunset walk?'),
  ('en', 'opener', 2, 'Your profile made me smile, and that doesn''t happen often. What made you smile today?'),
  ('en', 'opener', 3, 'I saw you love to travel. Where would you go back to tomorrow without a second thought?'),
  ('en', 'opener', 4, 'Hi! Looks like we have similar taste. What''s the best song you''ve discovered lately?'),
  ('en', 'opener', 5, 'I''m not great at first messages, so I''ll keep it simple: I''d love to get to know you.'),
  ('en', 'opener', 6, 'Serious question: pineapple on pizza, crime or genius? A lot depends on your answer 😄'),
  ('en', 'opener', 7, 'Your hiking photo made me want to go on an adventure. Where was it?'),
  ('en', 'opener', 8, 'If you could have a superpower just for this weekend, what would it be?'),
  -- Follow-ups: get back in touch without blame or pressure.
  ('en', 'follow_up', 1, 'Hey! I was thinking about our chat the other day. How was your week?'),
  ('en', 'follow_up', 2, 'I just saw something that made me think of you 😄 How are you doing?'),
  ('en', 'follow_up', 3, 'Just checking in, no pressure. I hope everything''s going well on your end.'),
  ('en', 'follow_up', 4, 'So, what''s the verdict on the show you told me about? I need to know if I should start it!'),
  ('en', 'follow_up', 5, 'We stopped right in the middle of a debate, and I still haven''t made up my mind. Have you?'),
  ('en', 'follow_up', 6, 'Seems like your week has been busy. Hang in there, and I look forward to hearing from you!'),
  ('en', 'follow_up', 7, 'Restarting our chat with an easy question: what was the best moment of your week?'),
  ('en', 'follow_up', 8, 'Hi! I didn''t want our conversation to fade out, I really enjoyed talking with you.'),
  -- Dates: suggest simply, leaving the door open.
  ('en', 'date', 1, 'I really enjoy talking with you. Want to keep it going over a drink this week?'),
  ('en', 'date', 2, 'I know a little café that makes the best hot chocolate in town. Up for checking it out with me?'),
  ('en', 'date', 3, 'We''ve been talking about walks for days… what if we went on one together this weekend?'),
  ('en', 'date', 4, 'I''d love to see you in person. Are you free Thursday or Friday evening?'),
  ('en', 'date', 5, 'Simple proposal: one drink, one hour, and we see if we get along as well as we do here. Interested?'),
  ('en', 'date', 6, 'There''s an exhibition that looks great right now. Would you like to go together?'),
  ('en', 'date', 7, 'I''m curious whether you''re as funny in person as you are over text. Coffee?'),
  ('en', 'date', 8, 'No pressure if it''s not the right time, but I''d really like for us to meet.'),
  -- Apologies: sincere, without over-justifying.
  ('en', 'apology', 1, 'I''m sorry about earlier. That wasn''t fair of me, and I understand that it hurt you.'),
  ('en', 'apology', 2, 'I owe you an apology: I took a long time to reply, and that''s not the impression I wanted to give.'),
  ('en', 'apology', 3, 'I''ve thought about what you said, and you''re right. I''m sorry.'),
  ('en', 'apology', 4, 'Sorry for cancelling at the last minute. I''d really like to make it up to you, if you''re okay with that.'),
  ('en', 'apology', 5, 'My message came out wrong, and I apologize. That''s not what I meant.'),
  ('en', 'apology', 6, 'I''m not looking for an excuse: I was wrong and I sincerely regret it.'),
  ('en', 'apology', 7, 'I understand if you need some time. I just wanted to tell you that I''m truly sorry.'),
  ('en', 'apology', 8, 'I shouldn''t have reacted that way. Thank you for telling me how you felt.'),
  -- Gentle breakups: clear, respectful, no false hope.
  ('en', 'soft_breakup', 1, 'I''ve had a good time with you, but I don''t feel what it would take to go further. I''d rather be honest with you.'),
  ('en', 'soft_breakup', 2, 'I want to be sincere: I don''t think we''re right for each other. I truly wish you the best.'),
  ('en', 'soft_breakup', 3, 'Thank you for our conversations. On my side, I''d rather not continue, and I wanted to tell you directly.'),
  ('en', 'soft_breakup', 4, 'You''re a great person, but I''m not in the right headspace for a relationship right now.'),
  ('en', 'soft_breakup', 5, 'I''d rather tell you than just disappear: I don''t want us to see each other again. Take care of yourself.'),
  ('en', 'soft_breakup', 6, 'I''ve thought about it a lot, and I think it''s best if we leave it here. Thank you for everything.'),
  ('en', 'soft_breakup', 7, 'This isn''t easy to write, but I don''t see a future for us. I didn''t want to leave you wondering.'),
  ('en', 'soft_breakup', 8, 'I have good memories of our time together, but I''d rather stop here. I hope you find what you''re looking for.');
