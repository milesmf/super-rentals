import { module, test } from 'qunit';
import { setupRenderingTest } from 'super-rentals/tests/helpers';
import { render } from '@ember/test-helpers';
import NavBar from 'super-rentals/components/nav-bar';

module('Integration | Component | nav-bar', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    // Updating values is achieved using autotracking, just like in app code. For example:
    // class State { @tracked myProperty = 0; }; const state = new State();
    // and update using state.myProperty = 1; await rerender();
    // Handle any actions with function myAction(val) { ... };

    await render(<template><NavBar /></template>);

    assert.dom().hasText('');

    // Template block usage:
    await render(<template>
      <NavBar>
        template block text
      </NavBar>
    </template>);

    assert.dom().hasText('template block text');
  });
});
