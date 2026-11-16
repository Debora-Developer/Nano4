# LembreMed 💊

**Transformando receitas médicas em uma rotina de cuidados mais organizada.**

O LembreMed é um aplicativo iOS desenvolvido durante a Apple Developer Academy, em um desafio de uma semana, com o objetivo de facilitar o gerenciamento de medicamentos por meio da inteligência artificial.

A aplicação utiliza a câmera do iPhone para capturar receitas médicas e a API Gemini para interpretar e transcrever automaticamente as informações dos medicamentos, tornando mais simples a organização dos horários e o acompanhamento das doses.

> Uma forma mais prática de cuidar de quem amamos — e de não esquecer de cuidar de nós mesmos.

## 💡 O problema

O projeto nasceu de uma experiência pessoal.

Ao receber minha mãe em casa por alguns dias, precisei ajudá-la a organizar medicamentos de uso contínuo e novos tratamentos iniciados após ela adoecer.

Com vários medicamentos, dosagens e horários diferentes, acompanhar a rotina se tornou um desafio. O maior problema não era apenas organizar as informações, mas garantir que nenhum horário fosse esquecido.

Foi dessa experiência que surgiu a ideia do LembreMed: utilizar tecnologia para tornar o acompanhamento dos medicamentos mais simples e intuitivo.

## ✨ A solução

O LembreMed propõe uma experiência que conecta a leitura de receitas médicas à organização da rotina de medicamentos.

### Funcionalidades propostas

- **Captura de receitas:** utilização da câmera nativa do iPhone para fotografar prescrições médicas.
- **Leitura inteligente:** integração com a API Gemini para reconhecer e transcrever medicamentos, dosagens e frequências.
- **Organização de medicamentos:** cadastro das informações e configuração de datas e horários.
- **Acompanhamento de doses:** registro de cada medicamento tomado por meio de um check.

## 🤖 Inteligência artificial

A inteligência artificial é parte central da experiência do LembreMed.

### Gemini API — IA dentro do produto

A API Gemini é utilizada para interpretar imagens de receitas médicas e extrair informações relevantes para o cadastro dos medicamentos.

O objetivo é reduzir a necessidade de transcrição manual e facilitar a transformação de uma prescrição fotografada em informações organizadas.

Durante os testes realizados, o modelo reconheceu corretamente nomes de medicamentos, dosagens e frequências.

**Atenção:** a interpretação automática deve sempre ser conferida pelo usuário antes de ser utilizada. A IA não substitui a prescrição nem a orientação de profissionais de saúde.

### Gemini — IA no processo de desenvolvimento

Além da integração com a API, utilizei o Gemini como assistente durante o desenvolvimento, apoiando a implementação e a resolução de desafios técnicos.

A concepção da solução, a definição dos fluxos, a elaboração dos prompts, a implementação e as decisões de desenvolvimento foram conduzidas individualmente por mim.

## 🛠️ Tecnologias utilizadas

| Tecnologia | Aplicação |
|---|---|
| Swift | Linguagem de programação |
| SwiftUI | Desenvolvimento da interface iOS |
| iOS 26 | Plataforma de desenvolvimento |
| Câmera nativa do iPhone | Captura das receitas médicas |
| Gemini API | Interpretação e transcrição das receitas |
| Gemini | Assistência durante o desenvolvimento |

## 👩🏻‍💻 Meu papel

**Desenvolvimento individual — Apple Developer Academy**

Fui responsável por todas as etapas de desenvolvimento do projeto, incluindo:

- Identificação do problema e concepção da solução.
- Definição da proposta e dos fluxos de utilização.
- Desenvolvimento das interfaces e implementação do código.
- Integração com a câmera nativa do iPhone.
- Integração com a API Gemini.
- Elaboração dos prompts para interpretação das receitas.
- Utilização de IA como apoio à programação.

## 📚 Aprendizados

O desenvolvimento do LembreMed proporcionou aprendizados importantes:

- Exploração dos recursos de câmera nativos da versão mais atual do iOS.
- Integração de uma API de inteligência artificial a uma aplicação mobile.
- Engenharia de prompts para extração de informações a partir de imagens.
- Utilização de IA como ferramenta de apoio ao desenvolvimento.
- Compreensão dos desafios de transformar informações não estruturadas em dados úteis para uma aplicação.

## 🚧 Status do projeto

O LembreMed encontra-se em estágio de protótipo em desenvolvimento, executável no ambiente Xcode.

A integração com a Gemini foi explorada e apresentou resultados positivos no reconhecimento das informações das receitas. Entretanto, o fluxo completo ainda não foi finalizado e o aplicativo não passou por testes com usuários externos.

### Próximos passos

- Finalizar e validar o fluxo completo de utilização.
- Implementar uma etapa de conferência das informações extraídas.
- Investigar e corrigir possíveis erros de interpretação da IA.
- Aprimorar a experiência de lembretes e acompanhamento das doses.
- Realizar testes de usabilidade.
- Reforçar a proteção de dados pessoais e informações de saúde.

---

**Desenvolvido por Débora Costa**

Apple Developer Academy | Desafio de desenvolvimento de uma semana

*Tecnologia a serviço do cuidado.*
