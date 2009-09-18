package com.googlecode.flexxb.persistence {

	/**
	 *
	 * @author aciobanu
	 *
	 */
	public final class ObjectActivity {
		public var item : Object;
		public var position : int;
		private var action : String;

		/**
		 * Constructor
		 * @param item
		 * @param position
		 * @param action
		 *
		 */
		public function ObjectActivity(item : Object, position : int, action : String = null) {
			this.item = item;
			this.position = position;
			this.action = action;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function isChanged() : Boolean {
			return !action;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function isAdded() : Boolean {
			return action == ChangeTrackerKind.ADD;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function isRemoved() : Boolean {
			return action == ChangeTrackerKind.REMOVE;
		}
	}
}