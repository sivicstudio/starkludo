# Title: Test Findings for Game Rules Implementation:

### Rolling the Dice:

i. Players take turns rolling the dice and moving their pieces according to the number rolled. Each piece starts in the home area.

#### Rules:

- Rule 1: The game starts with each player choosing a set of four pieces (usually colored red, blue, green, and yellow) and placing them on the starting square.

- Test Scenario: each player chooses a set of four pieces

- Expected Result:
When testing the game setup scenario, the expected result is that each player will choose a set of four pieces (usually colored red, blue, green, and yellow) and place them on the starting square as per Rule 1.

- Actual Result:
Upon testing the game setup scenario, the actual result confirmed that each player successfully chose a set of four pieces and placed them on the starting square following Rule 1. This scenario is marked as passed.
- [x] Passed

- Rule 2: The objective of the game is to move all four pieces around the board and return them to the starting square before your opponents.

- Test Scenario: move all four pieces around the board and return them to the starting square before your opponents.

- Expected Result:
All four pieces should be able to be moved around the board and returned to the starting square before the opponents.

- Actual Result:
All four pieces were successfully moved around the board and returned to the starting square before the opponents.
- [x] Passed

- Rule 3: On each turn, players roll two dice to determine how many spaces they can move their pieces.

- Test Scenario: players roll two dice on each turn to determine how many spaces they can move their pieces.

- Expected Result:
When players roll two dice on each turn, the expected outcome is that the total number rolled on the dice determines how many spaces the pieces can move. The sum of the two dice should range from 1 to 12.

- Actual Result:
Upon testing, it was observed that when players roll two dice on each turn, the total number rolled on the dice accurately determined the number of spaces the pieces could move. The sum of the two dice consistently ranged from 2 to 12, aligning with the expected behavior. This scenario is marked as "pass" as it performed as expected.
- [x] Passed

- Rule 4: The number on each die represents how many spaces a piece can move. For example, if a player rolls a 3 and a 6, they can move one piece 3 spaces and another piece 6 spaces.

- Test scenario: if a player rolls a 3 and a 6, they can move one piece 3 spaces and another piece 6 spaces.

- Expected result: When a player rolls a 3 and a 6, they should be able to move one game piece 3 spaces and another game piece 6 spaces according to the rules of the game.

- Actual result: Upon rolling a 3 and a 6, the player is indeed able to move one game piece 3 spaces and another game piece 6 spaces as expected, thereby meeting the requirements of the scenario.
- [x] Passed

- Rule 5: Pieces can only move forward, never backward.

- Test Scenario: Pieces can only move forward, never backward. 

- Expected Result:
The pieces should be restricted to moving only in a forward direction and should not be able to move backward.

- Actual Result:
After thorough testing, it has been confirmed that the pieces adhere to the expected behavior. They can only move forward and do not move backward, thus passing the test scenario.
- [x] Passed

- Rule 6: If a piece lands on a square occupied by an opponent’s piece, it can “knock off” that piece and send it back to the starting square.

- Test Scenario:
Verify the behavior when a piece lands on a square occupied by an opponent's piece.

- Expected Result:
When a piece lands on a square occupied by an opponent's piece, the opponent's piece should be sent back to the starting square, and the current piece should occupy the square.

- Actual Result:
Upon testing, it was observed that when a piece lands on a square occupied by an opponent's piece, the opponent's piece was not sent back to the starting square. Instead, both pieces remained on the same square, violating the "knock off" rule as per the game specifications.
- [x] Failed

- Rule 7: A piece can only be moved to a square that is empty or occupied by an opponent’s piece.

- Test Scenario: A piece can only be moved to a square that is empty

- Expected Result:
The piece should only be able to move to a square that is currently unoccupied.

- Actual Result:
The piece successfully moved to an empty square as per the test scenario. The test passed as expected.
- [x] Passed

- Rule 8: If a player rolls a double (two 6s), The Player stands a chance to play again (e.g, 6, 6, 6 can play continuously until the no 6 changes)

- Test Scenario: If a player rolls a double (two 6s), the player stands a chance to play again (e.g., 6, 6, 6 can play continuously until the number 6 changes).

- Expected Result: After rolling a double, the player should be allowed to continue playing with the same number until a different number is rolled.

- Actual Result: Upon rolling a double, the player was indeed allowed to continue playing with the same number until a different number was rolled. Therefore, the test has passed successfully.
- [x] Passed

- Rule 10: If a player has no piece on the board, they can only roll the dice to get 6, which allows them to enter a piece into play.

- Test Scenario: If a player has no piece on the board, they can only roll the dice to get 6, which allows them to enter a piece into play.

- Expected Result:
When a player has no piece on the board, they should only be able to roll the dice and move a piece into play if they roll a 6. 

- Actual Result:
Upon testing, it was observed that when a player has no piece on the board, they were only able to roll the dice and move a piece into play when they rolled a 6, in accordance with the expected behavior. This test scenario is marked as pass.
- [x] Passed

- Rule 11: The game ends when one player has all four pieces back on the starting square. That player is the winner.

- Test Scenario: The game ends when one player has all four pieces back on the starting square.

- Expected Result:
According to Rule 11, the game should end when one player successfully moves all four pieces back to the starting square. The winning player should be determined at this point.

- Actual Result:
Upon testing the scenario where one player has all four pieces back on the starting square, the game did not end and no winner was declared. This behavior deviates from the expected outcome as per Rule 11.
- [x] Failed

# Test Observations:
1. Following the game, it was observed that the visual quality of the congratulatory message displayed after player Red's victory was substandard.
2. Following the conclusion of the game, it was noted that despite player 1's victory, the game failed to terminate as expected, and instead continued.
3. During the course of the game, it was observed that if a player reaches their home and subsequently rolls the dice, they are able to click on the dice located in their home. This action prompts the same player to roll the dice again without the game progressing to the next player.
4. During the game, I observed that when one player's game piece encounters another player's piece, it fails to return the former piece to its starting point, which deviates from the expected game behavior.
5. I have observed that prior to a player rolling the die, there is no prompt indicating "It is your turn to roll the die, player red." Instead, the message consistently states, "Now it is your turn to move player red."














