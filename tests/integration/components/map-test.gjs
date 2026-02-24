import { module, test } from 'qunit';
import { setupRenderingTest } from 'super-rentals/tests/helpers';
import { render } from '@ember/test-helpers';
import Map from 'super-rentals/components/map';

module('Integration | Component | map', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    // Updating values is achieved using autotracking, just like in app code. For example:
    // class State { @tracked myProperty = 0; }; const state = new State();
    // and update using state.myProperty = 1; await rerender();
    // Handle any actions with function myAction(val) { ... };

    await render(<template><Map /></template>);

    assert.dom().hasText('');

    // Template block usage:
    await render(<template>
      <Map>
        template block text
      </Map>
    </template>);

    assert.dom().hasText('template block text');
  });
});
