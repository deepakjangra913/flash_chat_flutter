class Roundedbutton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const Roundedbutton({super.key, required this.text, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(text, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}