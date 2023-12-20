part of 'bill_splitter_cubit.dart';

@immutable
class BillSplitterState extends Equatable {
  final int?
      tipPercentage; //The percentage tip to be applied to the bill, controlled by a slider in the UI
  final int?
      personCounter; //The number of people to split the bill with, controlled by +- buttons in the UI
  final double?
      billAmount; //The total amount of the bill, controlled by a text field in the UI

  //const constructor for the state class. Since we always emit an entirely new state object, these values can be final.
  //They will never change, since a state is essentially a snapshot of a page at a given moment in time.
  //If the state changes, the entire state object is emitted, so these values will never be edited. They are immutable.
  const BillSplitterState({
    this.tipPercentage,
    this.personCounter,
    this.billAmount,
  });

  //This function optionally takes each value in the state, creates a new state object, fills
  //the values with either the passed-in value or the value in the current state ('this'), and
  //returns the new state object. The state returned from this function is ALWAYS a new state object,
  //with the same values as the previous state, except for any values that have been passed in.
  BillSplitterState copyWith({
    int? tipPercentage,
    int? personCounter,
    double? billAmount,
  }) {
    return BillSplitterState(
      tipPercentage: tipPercentage ?? this.tipPercentage,
      personCounter: personCounter ?? this.personCounter,
      billAmount: billAmount ?? this.billAmount,
    );
  }

  ///This function answers the question: "What values determine what's unique about this object?". In other words,
  ///the result of something like "state1 == state2" is determined by the values in this array being identical values
  ///in both state1 and state2. If they are, then the two states are considered equal. If they are not, then
  ///state1==state2 would be false.
  @override
  List<Object?> get props => [tipPercentage, personCounter, billAmount];
}
