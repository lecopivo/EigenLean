#pragma once

#include <lean/lean.h>

template<class T>
static void CppClass_finalize(void * obj){
  delete static_cast<T*>(obj);
}

template<class T>
static void CppClass_foreach(void *, b_lean_obj_arg){
  // do nothing since `S` does not contain nested Lean objects
}

template<class T>
static lean_external_class *CppClass_class = nullptr;

template<class T>
static inline lean_object * of_cppClass(T * t) {
    if (CppClass_class<T> == nullptr) {
        CppClass_class<T> = lean_register_external_class(CppClass_finalize<T>, CppClass_foreach<T>);
    }
    return lean_alloc_external(CppClass_class<T>, t);
}

template<class T>
static inline T * to_cppClass(b_lean_obj_arg o) {
  return static_cast<T *>(lean_get_external_data(o));
}

/** Ensures that external object is exclusive and thus can be mutated. The type `T` has to have copy constructor.
 */
template<class T>
lean_object * cppClass_make_exclusive(lean_object * o) {
  if (lean_is_exclusive(o)){
    return o;
  } else {
    auto const& t = *to_cppClass<T>(o);
    auto t_unique = new T{t};
    return of_cppClass(t_unique);
  }
}


