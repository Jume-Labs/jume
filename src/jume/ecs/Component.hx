package jume.ecs;

import jume.di.Injectable;

/**
 * Base component class.
 */
class Component implements Injectable {
  /**
   * The entity id this component belongs to.
   */
  public final entityId: Int;

  /**
   * The component container that holds all components on this entity.
   */
  final components: ComponentContainer;

  /**
   * Private constructor.
   * @param entityId 
   * @param components 
   */
  function new(entityId: Int, components: ComponentContainer) {
    this.entityId = entityId;
    this.components = components;
  }

  /**
   * Get another component that is on the entity this component is on.
   * @param componentType The type of component to get.
   * @return The component instance.
   */
  inline function getComponent<T: Component>(componentType: Class<T>): T {
    return components.get(componentType);
  }

  /**
   * Check if another component is on the entity this component is on.
   * @param componentType The type of component to check.
   * @return True if the component exists.
   */
  inline function hasComponent(componentType: Class<Component>): Bool {
    return components.has(componentType);
  }

  /**
   * Check if all components in a list are on the entity this component is on.
   * @param componentTypes A list of components to check.
   * @return True if all components exist.
   */
  inline function hasComponents(componentTypes: Array<Class<Component>>): Bool {
    return components.hasAll(componentTypes);
  }

  /**
   * Gets called when the component or entity is removed. Can be used for cleanup.
   */
  public function destroy() {}
}
