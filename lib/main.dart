import 'package:flutter/material.dart';

void main() => runApp(const QuizApp());

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Quiz',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6954C8)),
          scaffoldBackgroundColor: const Color(0xFFF6F5FA),
        ),
        home: const QuizPage(),
      );
}

class Question {
  const Question(this.text, this.options, this.answerIndex);
  final String text;
  final List<String> options;
  final int answerIndex;
}

const questions = <Question>[
  Question('Which function starts a Flutter app?', ['main()', 'start()', 'run()', 'init()'], 0),
  Question('Which widget arranges children vertically?', ['Row', 'Column', 'Stack', 'Wrap'], 1),
  Question('Which widget arranges children horizontally?', ['Row', 'Column', 'Scaffold', 'Center'], 0),
  Question('What does setState() tell Flutter?', ['Close the app', 'Rebuild after state changes', 'Add a route', 'Load an image'], 1),
  Question('Which widget is used for a scrollable list of known children?', ['ListTile', 'ListView', 'Divider', 'Card'], 1),
  Question('Which widget lets a user enter text?', ['TextField', 'Text', 'RichText', 'Tooltip'], 0),
  Question('What is the usual root widget for a Material app?', ['MaterialApp', 'Container', 'AppBar', 'SafeArea'], 0),
  Question('Which widget provides a button with filled styling?', ['Text', 'FilledButton', 'Padding', 'Icon'], 1),
  Question('What type represents true or false in Dart?', ['String', 'int', 'bool', 'double'], 2),
  Question('Which widget can show a determinate progress bar?', ['LinearProgressIndicator', 'Spacer', 'Divider', 'AspectRatio'], 0),
];

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _questionIndex = 0;
  int _score = 0;
  int? _selectedIndex;
  bool get _finished => _questionIndex >= questions.length;
  Question get _question => questions[_questionIndex];

  void _selectAnswer(int index) {
    if (_selectedIndex != null) return;
    setState(() {
      _selectedIndex = index;
      if (index == _question.answerIndex) _score++;
    });
  }

  void _next() => setState(() {
        _questionIndex++;
        _selectedIndex = null;
      });

  void _restart() => setState(() {
        _questionIndex = 0;
        _score = 0;
        _selectedIndex = null;
      });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Flutter Quiz'), centerTitle: true),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _finished ? _results(context) : _questionView(context),
              ),
            ),
          ),
        ),
      );

  Widget _questionView(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Question ${_questionIndex + 1} of ${questions.length}',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              Text('Score $_score', style: const TextStyle(color: Colors.blueGrey)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: (_questionIndex + 1) / questions.length, minHeight: 7),
          const SizedBox(height: 24),
          Text(_question.text,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          for (var i = 0; i < _question.options.length; i++) _answerButton(i),
          const Spacer(),
          if (_selectedIndex != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _selectedIndex == _question.answerIndex
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                _selectedIndex == _question.answerIndex
                    ? 'Correct!'
                    : 'Not quite. The correct answer is ${_question.options[_question.answerIndex]}.',
                style: TextStyle(
                  color: _selectedIndex == _question.answerIndex
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _next,
              child: Text(_questionIndex == questions.length - 1 ? 'See results' : 'Next question'),
            ),
          ],
        ],
      );

  Widget _answerButton(int index) {
    final answered = _selectedIndex != null;
    final isCorrect = index == _question.answerIndex;
    final isSelected = index == _selectedIndex;
    Color? background;
    if (answered && isCorrect) background = Colors.green.shade100;
    if (answered && isSelected && !isCorrect) background = Colors.red.shade100;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton(
        onPressed: answered ? null : () => _selectAnswer(index),
        style: OutlinedButton.styleFrom(
          backgroundColor: background,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          alignment: Alignment.centerLeft,
        ),
        child: Row(
          children: [
            Expanded(child: Text(_question.options[index])),
            if (answered && isCorrect) const Icon(Icons.check_circle, color: Colors.green),
            if (answered && isSelected && !isCorrect) const Icon(Icons.cancel, color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _results(BuildContext context) {
    final message = _score == questions.length
        ? 'Perfect score!'
        : _score >= questions.length ~/ 2
            ? 'Nice work! Keep practicing.'
            : 'Good start. Try another round!';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.emoji_events_outlined, size: 66, color: Color(0xFF6954C8)),
        const SizedBox(height: 18),
        Text('Quiz complete', textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text('$_score / ${questions.length}', textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 28),
        FilledButton.icon(onPressed: _restart, icon: const Icon(Icons.refresh), label: const Text('Restart quiz')),
      ],
    );
  }
}

