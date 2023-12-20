import 'package:bizcardapp/ui/bill_splitter/bill_splitter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillSplitter extends StatefulWidget {
  const BillSplitter({super.key});

  @override
  State<BillSplitter> createState() => _BillSplitterState();
}

class _BillSplitterState extends State<BillSplitter> {
  @override
  Widget build(BuildContext context) {
    //The base-level widget needed for Cubit is a BlocProvider. These are responsible
    //for creating a new instance of your cubit, and making it available to the children in your widget tree.
    //If you do not have a blocProvider above your BlocBuilder, it will NOT find the cubit in your tree/context.
    return BlocProvider(
      create: (context) {
        BillSplitterCubit cubit = BillSplitterCubit();

        return cubit; //create your new cubit here, do any required initialization work,
        //and return the cubit instance.
      },
      //The BlocBuilder is a widget that listens to the cubit for state changes, and rebuilds the UI when this occurs.
      //It requires you to provide the cubit/state classes in the angle brackets, so that it knows which cubit to go looking for
      //in the widget tree. If you do not have a blocBuilder, the page will not update when emit() is called.
      child: BlocBuilder<BillSplitterCubit, BillSplitterState>(
        builder: (context, state) {
          //Here, we need to get a reference to the actual cubit. The BlocBuilder gives us access to the state,
          //but to call cubit functions, we need a cubit object to call functions on, and we get it by doing:
          BillSplitterCubit cubit = context.read<BillSplitterCubit>();

          return Scaffold(
            body: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1),
              alignment: Alignment.center,
              color: Colors.white,
              child: ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(20.5),
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: cubit.purple.withOpacity(
                            0.1), //This color object is a property of the cubit, though it does not have to be.
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Total Per Person",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: cubit.purple),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              " \$ ${cubit.calculateTotalPerPerson()}", //This function
                              //calculates the total per person BASED ON the values in the current BillSplitterState, and returns the string.
                              style: TextStyle(
                                  fontSize: 34.9,
                                  fontWeight: FontWeight.normal,
                                  color: cubit.purple),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Colors.blueGrey.shade100,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(color: cubit.purple),
                          decoration: InputDecoration(
                              hintText: "Bill Amount ",
                              prefixIcon: Icon(Icons.attach_money)),
                          onChanged: (String value) {
                            //this cubit function manually updates the bill amount passed in by emitting a new state with that value.
                            cubit.updateBillAmount(value);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Split",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    //This cubit function will decrease the person counter from the current state,
                                    //and emit a new state with this decreased value. All validation is handled internally.
                                    cubit.decreasePersonCounter();
                                  },
                                  child: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    margin: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                        color: cubit.purple.withOpacity(0.1)),
                                    child: Center(
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                            color: cubit.purple,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "${state.personCounter}", //here, we're simply displaying the person counter in the current state of the page.
                                  style: TextStyle(
                                      color: cubit.purple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0),
                                ),
                                InkWell(
                                  onTap: () {
                                    //this cubit function will find the current person count in state, increment it, and emit a new state with this value.
                                    cubit.increasePersonCounter();
                                  },
                                  child: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    margin: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: cubit.purple.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(7.0)),
                                    child: Center(
                                      child: Text(
                                        "+",
                                        style: TextStyle(
                                            color: cubit.purple,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        // Tip
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Tip",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                "\$ ${(cubit.calculateTotalTip()).toStringAsFixed(2)}", //this function handles the business logic of
                                //calculating the tip based on the current state, and returns that value as a string. No new states are emitted here,
                                //just doing calculations on the current state's values and displaying it here.
                                style: TextStyle(
                                    color: cubit.purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                            )
                          ],
                        ),
                        //Slider
                        Column(
                          children: <Widget>[
                            // ...
                            //Slider
                            Column(
                              children: <Widget>[
                                Text(
                                  "${state.tipPercentage}%", //again, just displaying the current state's tip percentage here.
                                  style: TextStyle(
                                    color: cubit.purple,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ), // Added comma here
                                Slider(
                                  value: (state.tipPercentage ?? 0)
                                      .toDouble(), //same here as well. No change in state, just displaying
                                  //the current value.
                                  min: 0,
                                  max: 100,
                                  activeColor: cubit.purple,
                                  inactiveColor: Colors.grey,
                                  divisions: 10,
                                  onChanged: (double newValue) {
                                    //this function will take the new value from this UI control, and update the
                                    //page by emitting a new state with this updated value
                                    cubit.updateTipPercentage(newValue.round());
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
