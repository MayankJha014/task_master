import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:task_master/components/project-detail/services/project_service.dart';
import 'package:task_master/model/user.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String taskId;
  const SearchScreen({super.key, required this.taskId});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  List<User>? userList;

  final ProjectService projectService = ProjectService();

  final TextEditingController searchController = TextEditingController();
  String? friendId;

  void addFriend() async {
    projectService.addFriends(
      context: context,
      id: widget.taskId,
      ref: ref,
      userId: friendId!,
    );
  }

  void fetchFriends({required String query}) async {
    userList = await projectService.fetchSearchFriends(
        context: context, displayName: searchController.text, ref: ref);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Image(
          image: AssetImage(
            'assets/scaffold.png',
          ),
          fit: BoxFit.cover,
        ),
        leading: const BackButton(color: Colors.black),
        automaticallyImplyLeading: true,
        elevation: 2.5,
        title: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 1,
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      value != '' ? fetchFriends(query: value) : () {};
                    },
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      prefixIcon: InkWell(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 23,
                          ),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(top: 10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      hintText: 'Search Your Friend',
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 0,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/scaffold.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            userList != null
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: userList!.length,
                    itemBuilder: (context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                            )
                          ],
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage:
                                  userList![index].profilePicture == ''
                                      ? const NetworkImage(
                                          'https://w0.peakpx.com/wallpaper/996/1002/HD-wallpaper-goku-red-dragonball-super-goku-son-goku-fire-hair.jpg',
                                        )
                                      : NetworkImage(
                                          userList![index].profilePicture!),
                              // fit: BoxFit.fill,
                            ),
                            Column(
                              children: [
                                Text(
                                  userList![index].displayName,
                                  style: GoogleFonts.patuaOne(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                Text(
                                  userList![index].uniqueId,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  friendId = userList![index].id;
                                });
                                addFriend();
                              },
                              child: const CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.black,
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.person_add_alt_1,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    })
                : Center(
                    child: Lottie.asset(
                      'assets/loading.json',
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
