import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty_freezed/bloc/character_bloc.dart';
import 'package:rick_morty_freezed/data/models/character.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Character _currentCharacter;
  List<Results> _currentResult = [];
  int _currentPage = 1;
  String _currentSearchStr = '';

  @override
  void initState() {
    if (_currentResult.isEmpty) {
      context
          .read<CharacterBloc>()
          .add(const CharacterEvent.started(name: '', page: 1));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterBloc>().state;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 15, bottom: 1, left: 16, right: 16),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(86, 86, 86, 0.8),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: "Search Name",
              hintStyle: const TextStyle(color: Colors.white),
            ),
            onChanged: (value) {
              _currentPage = 1;
              _currentResult = [];
              _currentSearchStr = value;
              context
                  .read<CharacterBloc>()
                  .add(CharacterEvent.started(name: value, page: 1));
            },
          ),
        ),
        Expanded(
          child: state.when(
            initial: () => const SizedBox(),
            loading: () {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text('Loading...'),
                  ],
                ),
              );
            },
            loaded: (characterLoaded) {
              _currentCharacter = characterLoaded;
              _currentResult = _currentCharacter.results;
              return _currentResult.isNotEmpty
                  ? _customListView(_currentResult)
                  : const SizedBox();
            },
            error: () => const Text("Nothing found..."),
          ),
        ),
      ],
    );
  }
}

Widget _customListView(List<Results> currentResults) {
  return ListView.separated(
    itemBuilder: (context, index) {
      final resilt = currentResults[index];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        child: ListTile(
          title: Text(
            resilt.name,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    },
    separatorBuilder: (_, index) => const SizedBox(height: 5),
    itemCount: currentResults.length,
  );
}
