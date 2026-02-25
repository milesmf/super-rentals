import { module, test } from 'qunit';
import { setupRenderingTest } from 'super-rentals/tests/helpers';
import { render } from '@ember/test-helpers';
import Detailed from 'super-rentals/components/rental/detailed';

module('Integration | Component | rental/detailed', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    // Updating values is achieved using autotracking, just like in app code. For example:
    // class State { @tracked myProperty = 0; }; const state = new State();
    // and update using state.myProperty = 1; await rerender();
    // Handle any actions with function myAction(val) { ... };

    await render(<template><Detailed /></template>);

    assert.dom().hasText('');

    // Template block usage:
    await render(<template>
      <Detailed>
        template block text
      </Detailed>
    </template>);

    assert.dom().hasText('template block text');
  });
});
