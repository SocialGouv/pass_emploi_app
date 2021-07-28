import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pass_emploi_app/presentation/home_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';

class ActionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(
      converter: (store) => HomeViewModel.create(store),
      builder: (context, viewModel) => _body(),
    );
  }

  Scaffold _body() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.blue, AppColors.purple],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: Margins.medium, top: 68),
                child: Text(
                  "Mes actions",
                  style: GoogleFonts.rubik(
                    color: AppColors.nightBlue,
                    fontSize: FontSizes.huge,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
            Container(
              height: 700,
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Margins.medium),
                    child: Text(
                      "Mes actions à faire",
                      style: GoogleFonts.rubik(
                        color: AppColors.nightBlue,
                        fontSize: FontSizes.large,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
