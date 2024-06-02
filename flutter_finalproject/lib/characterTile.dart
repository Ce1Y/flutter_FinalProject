import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_finalproject/character.dart';
import 'package:flutter_finalproject/characterDetailTile.dart';

class CharacterTile extends StatefulWidget {
  const CharacterTile({super.key, required this.character});

  final Character character;

  @override
  State<CharacterTile> createState() => _CharacterTile();
}

class _CharacterTile extends State<CharacterTile> {
  late bool _showFrontSide;
  late bool _flipXAxis;

  @override
  initState() {
    super.initState();
    _flipXAxis = true;
    _showFrontSide = true;
  }

// Card front widget
  Widget _buildFront() {
    return Card(
      key: const ValueKey(true),
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      elevation: 5,
      child: Container(
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 200,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.network(
                    'https://jojos-bizarre-api.netlify.app/assets/${widget.character.image}'),
              ),
            ),
            Text(
              widget.character.name.isEmpty
                  ? "Not found`"
                  : widget.character.name,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

// Card rear widget
  Widget _buildRear() {
    return Card(
      key: const ValueKey(false),
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      elevation: 5,
      child: SizedBox(
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CharacterDetailTile(character: widget.character),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                side: const BorderSide(width: 3.0, color: Colors.purple),
              ),
              child: const Text("Profile"),
            ),
          ],
        ),
      ),
    );
  }

// Build card widget
  Widget _buildFlipAnimation() {
    return InkWell(
      onTap: () => setState(() => _showFrontSide = !_showFrontSide),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: _transitionBuilder,
        layoutBuilder: (widget, list) =>
            Stack(children: [widget ?? const SizedBox(), ...list]),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
        child: _showFrontSide ? _buildFront() : _buildRear(),
      ),
    );
  }

// Card flip animation
  Widget _transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget?.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFlipAnimation();
  }
}
