import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_finalproject/character.dart';
import 'package:flutter_finalproject/characterDetailTile.dart';
import 'package:flip_card/flip_card.dart';

class CharacterTile extends StatefulWidget {
  const CharacterTile({super.key, required this.character});

  final Character character;

  @override
  State<CharacterTile> createState() => _CharacterTile();
}

class _CharacterTile extends State<CharacterTile> {
  late bool _showFrontSide;
  late bool _flipXAxis;

  initState() {
    super.initState();
    _flipXAxis = true;
    _showFrontSide = true;
  }

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

  Widget _buildRear() {
    return Card(
      key: const ValueKey(false),
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
            Text("test"),
          ],
        ),
      ),
    );
  }

  Widget _buildFlipAnimation() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CharacterDetailTile(character: widget.character),
          ),
        );
      },
      //TODO: No hover detection
      //TODO: MouseRegion only has onEnter, onExit and onHover, no onTap function
      //TODO: Solution: let front and rear side both use inkwell with card be the child
      // onHover: (value) => setState(() => _showFrontSide = !_showFrontSide),
      onLongPress: () => setState(() => _showFrontSide = !_showFrontSide),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: _transitionBuilder,
        layoutBuilder: (widget, list) =>
            Stack(children: [widget ?? const SizedBox(), ...list]),
        child: _showFrontSide ? _buildFront() : _buildRear(),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
      ),
    );
  }

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
    // return InkWell(
    //   onTap: () {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) =>
    //             CharacterDetailTile(character: widget.character),
    //       ),
    //     );
    //   },
    //   child: Card(
    //     color: Colors.white,
    //     shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(5.0)),
    //     ),
    //     elevation: 5,
    //     child: Container(
    //       width: 150,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           SizedBox(
    //             height: 200,
    //             child: Align(
    //               alignment: Alignment.bottomCenter,
    //               child: Image.network(
    //                   'https://jojos-bizarre-api.netlify.app/assets/${widget.character.image}'),
    //             ),
    //           ),
    //           Text(
    //             widget.character.name.isEmpty
    //                 ? "Not found`"
    //                 : widget.character.name,
    //             textAlign: TextAlign.center,
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return _buildFlipAnimation();
  }
}
