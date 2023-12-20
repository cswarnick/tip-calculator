import 'dart:ui';
import 'package:bizcardapp/util/hexcolor.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'bill_splitter_state.dart';

///This Cubit class is responsible for containing all business logic related to the Bill Splitter widget,
///as well as managing the state of any widgets that rely on this cubit. Having this class will
///ensure that the widget will ONLY contain code that's relevant to displaying the UI, as well as
///freeing the widget class from the responsibility of managing its own state.
class BillSplitterCubit extends Cubit<BillSplitterState> {
  Color purple = HexColor(
      "#6908D6"); //This value is used exclusively in the UI, and could therefore stay there,
  //but we've stashed this here for now.

  //The constructor for this class. It takes nothing, and initializes both the cubit and it's initial state.
  //This is where you would want to provide your initial state values for the first display of the widget.
  //if you had initialization work to do (say, for an API call), you would likely do it here.
  BillSplitterCubit()
      : super(BillSplitterState(
            tipPercentage: 0, personCounter: 1, billAmount: 0.0));

  //This function is responsible for formatting the caluclation done in calculateTotalTip into a string.
  String calculateTotalPerPerson() {
    var totalPerPerson = (calculateTotalTip() + (state.billAmount ?? 0)) /
        (state.personCounter ?? 1);

    return totalPerPerson.toStringAsFixed(2);
  }

  //this function is responsible for doing the calculation to determine the total tip amount.
  //This would be a prime example of a business logic function. While the UI relies on this calculation,
  //the function itself does not contain anything related to UI/rendering, therefore it does not belong in the widget class.
  double calculateTotalTip() {
    double totalTip = 0.0;

    //for any state value (which should be nullable), we need to provide a default value in case the value is null.
    //when in doubt, use the initial values that are passed by default to the state constructor on lines 22-23.
    if ((state.billAmount ?? 0.0) < 0 || state.billAmount.toString().isEmpty) {
    } else {
      totalTip = ((state.billAmount ?? 0) * (state.tipPercentage ?? 0)) / 100;
    }

    return totalTip;
  }

  //This function takes in a bill amount as a string, parses it as a double, and rebuilds
  // the UI by emitting a new state with the updated value.
  void updateBillAmount(String amount) {
    double _billAmount = 0.0;
    try {
      _billAmount = double.parse(amount);
    } catch (exception) {
      _billAmount = 0.0;
    }

    emit(state.copyWith(
        billAmount: _billAmount)); //this line will update any widget
    //that is wrapped in a BillSplitter BlocBuilder, and references state.billAmount somewhere in the UI.
  }

  ///This function takes nothing in, increments the person counter by one, and emits a new state with that updated value.
  void increasePersonCounter() {
    int _personCounter = state.personCounter ?? 1;

    _personCounter++;

    emit(state.copyWith(
        personCounter: _personCounter)); //this line will update any widget
    //that is wrapped in a BillSplitter BlocBuilder, and references state.personCounter somewhere in the UI.
  }

  //same as above, but decrements the person counter by one. Used by the - button in the UI.
  void decreasePersonCounter() {
    int _personCounter = state.personCounter ?? 1;
    if (_personCounter > 1) {
      _personCounter--;
    }

    emit(state.copyWith(personCounter: _personCounter));
  }

  //This function takes in a tip percentage as an int, and emits a new state with that updated value.
  //Any widget that is wrapped in a BillSplitter BlocBuilder and references state.tipPercentage somewhere in the UI
  //will be updated when this runs.
  void updateTipPercentage(int tipPercentage) {
    emit(state.copyWith(tipPercentage: tipPercentage));
  }
}
