'reach 0.1';//Indacte it as a reach program

const Player = {
    getHand :Fun([], UInt),
    seeOutcome: Fun([UInt], Null),
};
export const main = Reach.App(() => { //compiler
    const Alice = Participant("Alice", { 
        ...Player,
        wager: UInt,
        //Specs interact here
    })
    const Bob = Participant("Bob", {
        ...Player,
        acceptWager: Fun([UInt], Null),
        //Specs interact here
    });
    init();
    //Program goes here.
    
    Alice.only(() => {
        const wager = declassify(interact.wager)
        const handAlice = declassify(interact.getHand());
      });
      Alice.publish(wager,handAlice).pay(wager);
      commit();
    Bob.only(() => {
        interact.acceptWager(wager);
        const handBob = declassify(interact.getHand());
      });

    Bob.publish(handBob).pay(wager);

    const outcome = (handAlice + (4 - handBob)) % 3;
    const            [forAlice, forBob] =
    outcome == 2 ? [       2,      0] :
    outcome == 0 ? [       0,      2] :
    /* tie      */ [       1,      1];
    transfer(forAlice * wager).to(Alice);
    transfer(forBob   * wager).to(Bob);

    commit();

    each([Alice, Bob], () => {
        interact.seeOutcome(outcome);
    });
});
